# `EscapeAnalysis`

`Compiler.EscapeAnalysis`は、[Julia's SSA-form IR](@ref Julia-SSA-form-IR)（別名`IRCode`）のエスケープ情報を解析するためのコンパイラユーティリティモジュールです。

このエスケープ解析の目的は次のとおりです。

  * Juliaの高水準な意味論を活用し、特にプロシージャ間呼び出しを通じたエスケープやエイリアシングを推論する
  * [alias-aware SROA](https://github.com/JuliaLang/julia/pull/43888)、[early `finalize` insertion](https://github.com/JuliaLang/julia/pull/44056)、[copy-free `ImmutableArray` construction](https://github.com/JuliaLang/julia/pull/42465)、可変オブジェクトのスタック割り当てなど、さまざまな最適化に利用できる汎用性を備える
  * 完全な後向きデータフロー解析の実装と、直交する格子の性質を組み合わせた新しい格子設計に基づき、シンプルに実装する

## Try it out!

テストやデバッグ用の便利なエントリポイント`code_escapes`と`@code_escapes`を定義するユーティリティスクリプト`EAUtils.jl`を読み込むと、エスケープ解析を試すことができます。

```@repl EAUtils
# InteractiveUtils.@activate Compiler # to use the stdlib version of the Compiler

let JULIA_DIR = normpath(Sys.BINDIR, Base.DATAROOTDIR, "julia")
    include(normpath(JULIA_DIR, "Compiler", "test", "EAUtils.jl"))
    using .EAUtils
end

mutable struct SafeRef{T}
    x::T
end
Base.getindex(x::SafeRef) = x.x;
Base.setindex!(x::SafeRef, v) = x.x = v;
Base.isassigned(x::SafeRef) = true;
get′(x) = isassigned(x) ? x[] : throw(x);

result = code_escapes((Base.RefValue{String},String,String,)) do r1, s2, s3
    r2 = Ref(s2)
    r3 = SafeRef(s3)
    try
        s1 = get′(r1)
        ret = sizeof(s1)
    catch err
        global GV = err # `r1` may escape
    end
    s2 = get′(r2)       # `r2` doesn't escape
    s3 = get′(r3)       # `r3` doesn't escape
    return s2, s3, s4
end
```

各呼び出し引数とSSA文の横に表示される記号は、次の意味を表します。

  * `◌`（通常表示）：この値のエスケープ情報は利用されないため、解析対象ではありません（たとえば、オブジェクトが`isbitstype`の場合）
  * `✓`（緑またはシアン）：この値はエスケープしません（`has_no_escape(result.state[x])`が成立）。引数エスケープもある場合は青色で表示されます（`has_arg_escape(result.state[x])`が成立）
  * `↑`（青または黄色）：この値は戻り値を通じて呼び出し元へエスケープする可能性があります（`has_return_escape(result.state[x])`が成立）。未処理の例外エスケープもある場合は黄色で表示されます（`has_thrown_escape(result.state[x])`が成立）
  * `X`（赤）：この値は、グローバルメモリへのエスケープなど、エスケープ解析で推論できない場所へエスケープする可能性があります（`has_all_escape(result.state[x])`が成立）
  * `*`（太字）：この値のエスケープ状態は、`ReturnEscape`と`AllEscape`の間にあります（[`EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo)の半順序において）。未処理の例外エスケープもある場合は黄色で表示されます（`has_thrown_escape(result.state[x])`が成立）
  * `′`：この値の`AliasInfo`プロパティには、オブジェクトのフィールドや配列要素に関する追加情報があります

各呼び出し引数とSSA値のエスケープ情報は、次のようにプログラムから調べられます。

```@repl EAUtils
result.state[Core.Argument(3)] # get EscapeInfo of `s2`

result.state[Core.SSAValue(3)] # get EscapeInfo of `r3`
```

## Analysis Design

### Lattice Design

`EscapeAnalysis`は、[data-flow analysis](https://en.wikipedia.org/wiki/Data-flow_analysis)として実装されており、[`x::EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo)の格子上で動作します。この格子は、次のプロパティで構成されます。

  * `x.Analyzed::Bool`：形式上は格子の一部ではなく、`x`が解析済みかどうかだけを示します
  * `x.ReturnEscape::BitSet`：`x`が戻り値を通じて呼び出し元へエスケープする可能性のあるSSA文を記録します
  * `x.ThrownEscape::BitSet`：`x`が例外としてスローされる可能性のあるSSA文を記録します（後述する[exception handling](@ref EA-Exception-Handling)で使用）
  * `x.AliasInfo`：`x`のフィールドや配列要素にエイリアスされる可能性のある値をすべて保持します（後述する[alias analysis](@ref EA-Alias-Analysis)で使用）
  * `x.ArgEscape::Int`（未実装）：引数の`setfield!`を通じて呼び出し元へエスケープすることを示します

入力プログラムの文数が有限であるという不変条件（Juliaの意味論によって保証されます）のもとでは、これらの属性を組み合わせて有限の高さを持つ半順序格子を構成できます。この格子設計の巧妙な点は、各格子プロパティを個別に扱えるため、格子演算をよりシンプルに実装できることです[^LatticeDesign]。

### Backward Escape Propagation

このエスケープ解析の実装は、論文[^MM02]で説明されているデータフローアルゴリズムに基づいています。解析では`EscapeInfo`の格子を使い、未解析のSSA文に対応するプログラムカウンタを保持する（概念上の）作業集合を管理しながら、すべての格子要素が不動点に収束するまで、格子要素を底から上へ遷移させます。解析は、各引数とSSA文の`EscapeInfo`を追跡する単一のグローバル状態を管理します。ただし、ある程度のフロー感度は、`EscapeInfo`の`ReturnEscape`プロパティに記録されたプログラムカウンタによって表現されている点にも注意してください。必要に応じて、後から支配関係解析と組み合わせ、フロー感度を推論できます。

このエスケープ解析の特徴的な設計の一つは、完全な*後向き*解析であることです。つまり、エスケープ情報は*使用箇所から定義へ*流れます。たとえば、以下のコード片では、EAはまず文`return %1`を解析し、`%1`（`obj`に対応）に`ReturnEscape`を課します。次に`%1 = %new(Base.RefValue{Base.RefValue{String}, _2}))`を解析し、`%1`に課された`ReturnEscape`を、呼び出し引数`_2`（`s`に対応）へ伝播します。

```@repl EAUtils
code_escapes((Base.RefValue{String},)) do s
    obj = Ref(s)
    return obj
end
```

重要なのは、この後向き解析では、エスケープ情報が制御フローではなく、使用・定義チェーンに沿って自然に流れることです[^BackandForth]。その結果、エスケープ解析をシンプルに実装できます。たとえば`PhiNode`は、`PhiNode`に課されたエスケープ情報を、その先行値へ伝播するだけで処理できます。

```@repl EAUtils
code_escapes((Bool, Base.RefValue{String}, Base.RefValue{String})) do cnd, s, t
    if cnd
        obj = Ref(s)
    else
        obj = Ref(t)
    end
    return obj
end
```

### [Alias Analysis](@id EA-Alias-Analysis)

`EscapeAnalysis`は、オブジェクトのフィールドに課されるエスケープを一定の精度で推論するため、後向きのフィールド解析を実装しています。この目的で、`x::EscapeInfo`の`x.AliasInfo`プロパティが使われます。このプロパティは、「使用箇所」で`x`のフィールドにエイリアスされる可能性のある値をすべて記録し、その後「定義箇所」で、記録された値のエスケープ情報を実際のフィールド値へ伝播します。具体的には、`getfield`呼び出しを解析して、オブジェクトのフィールドにエイリアスされる可能性のある値を記録し、`%new(...)`式または`setfield!`呼び出し[^Dynamism]を解析する際に、その値のエスケープ情報をフィールドへ伝播します。

```@repl EAUtils
code_escapes((String,)) do s
    obj = SafeRef("init")
    obj[] = s
    v = obj[]
    return v
end
```

上の例では、`%3`（`v`に対応）に課された`ReturnEscape`は、`%1`（`obj`に対応）へ直接伝播するのではなく、`ReturnEscape`だけが`_2`（`s`に対応）へ伝播します。ここでは、`%3`が`%1`の`AliasInfo`プロパティに記録されます。これは、`%1`の第1フィールドにエイリアスされる可能性があるためです。その後、`Base.setfield!(%1, :x, _2)::String`を解析すると、そのエスケープ情報は`_2`へ伝播しますが、`%1`へは伝播しません。

つまり、`EscapeAnalysis`は、オブジェクトのフィールドのエスケープを解析するため、`getfield`-`%new`/`setfield!`チェーンをまたいで、どのIR要素がエイリアスされるかを追跡します。しかし、このエイリアス解析は、ほかのIR要素も扱えるよう一般化する必要があります。Julia IRでは、同じオブジェクトが異なるIR要素で表されることがあるため、実際には同じオブジェクトを表し得るIR要素どうしで、同じエスケープ情報を共有する必要があるからです。`PiNode`や`typeassert`のように、オペランドの値をそのまま返すIR要素は、IRレベルのエイリアシングを引き起こす可能性があります。そのため、こうしたエイリアス値のいずれかに課されたエスケープ情報は、値どうしで共有する必要があります。さらに、`PhiNode`への変更を正しく推論するうえでも、この処理が必要です。次の例を考えてみましょう。

```@repl EAUtils
code_escapes((Bool, String,)) do cond, x
    if cond
        ϕ2 = ϕ1 = SafeRef("foo")
    else
        ϕ2 = ϕ1 = SafeRef("bar")
    end
    ϕ2[] = x
    y = ϕ1[]
    return y
end
```

`ϕ1 = %5`と`ϕ2 = %6`はエイリアスされているため、`%8 = Base.getfield(%6, :x)::String`（`y = ϕ1[]`に対応）に課された`ReturnEscape`は、`Base.setfield!(%5, :x, _3)::String`（`ϕ2[] = x`に対応）にも伝播する必要があります。このエスケープ情報を正しく伝播するには、`ϕ1`と`ϕ2`の*先行値*もエイリアスされる可能性があると認識し、それらのエスケープ情報を同一化する必要があります。

このようなエイリアス情報の興味深い性質として、「使用箇所」では分からず、「定義箇所」でしか導出できない点があります（エイリアシングは概念上、代入と等価です）。そのため、後向き解析には自然には適合しません。関連する値の間でエスケープ情報を効率よく伝播するため、EscapeAnalysis.jlは、古いJVMの論文[^JVM05]で説明されているエスケープ解析アルゴリズムに着想を得た手法を使います。つまり、エスケープ格子要素の管理に加えて、「同値」エイリアス集合も管理します。これは、エイリアスされた引数とSSA文をまとめた互いに素な集合です。この集合は、互いにエイリアスされる可能性のある値を管理し、そのいずれかに課されたエスケープ情報を値どうしで同一化します。

### [Array Analysis](@id EA-Array-Analysis)

前述のオブジェクトフィールド向けエイリアス解析は、配列操作の解析にも一般化できます。`EscapeAnalysis`は、さまざまなプリミティブ配列操作を処理します。これにより、`arrayref`-`arrayset`の使用・定義チェーンを通じてエスケープを伝播し、割り当てた配列を過度に保守的にエスケープ扱いすることを避けられます。

```@repl EAUtils
code_escapes((String,)) do s
    ary = Any[]
    push!(ary, SafeRef(s))
    return ary[1], length(ary)
end
```

上の例では、`EscapeAnalysis`は、`%20`と`%2`（割り当てられたオブジェクト`SafeRef(s)`に対応）が、`arrayset`-`arrayref`チェーンを通じてエイリアスされることを認識し、それらに`ReturnEscape`を課します。一方、割り当てられた配列`%1`（`ary`に対応）には課しません。`EscapeAnalysis`は、`ary`にも`ThrownEscape`を課します。これは、`BoundsError`を通じたエスケープの可能性も考慮する必要があるためです。ただし、最適化時には、このように未処理の`ThrownEscape`を無視できることが多い点にも注意してください。たとえば、`ary`の割り当てを最適化する場合が該当します。

さらに、配列のインデックス情報と次元を*正確に*把握できる場合、`EscapeAnalysis`は、オブジェクトに対して`EscapeAnalysis`が「フィールドごと」のエイリアス解析を行うのと同様に、`arrayref`-`arrayset`チェーンを通じた「要素ごと」のエイリアシングまで推論できます。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Vector{Any}(undef, 2)
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

`ReturnEscape`は`%2`（`SafeRef(s)`に対応）にのみ課され、`%4`（`SafeRef(t)`に対応）には課されない点に注意してください。これは、割り当てられた配列の次元と、すべての`arrayref`/`arrayset`操作で使われるインデックスが定数情報として得られるためです。`EscapeAnalysis`は、`%6`が`%2`にエイリアスされる一方、`%4`には決してエイリアスされないと推論できます。このような場合、後続の最適化パスで`Base.arrayref(true, %1, 1)::Any`を`%2`に置き換えられます（「ロード転送」とも呼ばれます）。最終的には、配列`%1`の割り当てを完全に除去できます（「スカラー置換」とも呼ばれます）。

オブジェクトフィールドの解析では、型推論から得られる型情報を使ってフィールドへのアクセスを簡単に解析できます。一方、配列の次元は型情報に含まれないため、その情報を導出する追加の解析が必要です。現時点で`EscapeAnalysis`は、まず単純な線形走査を追加で行って割り当てられた配列の次元を解析し、その後メインの解析ルーチンを実行します。これにより、後続のエスケープ解析で配列操作を正確に解析できます。

ただし、このような正確な「要素ごと」のエイリアス解析は難しいことがよくあります。配列に固有の主な難しさは、配列の次元やインデックスが定数でないことが多い点です。

  * ループによって、ループごとに変化する非定数の配列インデックスが生成されることが多い
  * （ベクトルに固有の問題として）配列のリサイズによって次元が変わり、定数性が失われる

具体例を使って、これらの難しさを見ていきましょう。

次の例では、`EscapeAnalysis`は正確なエイリアス解析に失敗します。`Base.arrayset(false, %4, %8, %6)::Vector{Any}`のインデックスが（自明には）定数でないためです。特に、`Any[nothing, nothing]`はループを形成し、その中で`arrayset`操作を呼び出します。このとき、`%6`はϕノード値（制御フローに依存する値）として表されます。その結果、`ReturnEscape`は、`%23`（`SafeRef(s)`に対応）と`%25`（`SafeRef(t)`に対応）の両方に課されます。本来は`%23`だけに課し、`%25`には課さないのが理想です。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[nothing, nothing]
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

次の例では、ベクトルのリサイズによって正確なエイリアス解析が難しくなる様子を示します。主な問題は、割り当てられた配列`%1`の次元が最初は`0`として初期化されるものの、その後の2回の`:jl_array_grow_end`呼び出しによって変化することです。現時点で`EscapeAnalysis`は、配列のリサイズ操作に遭遇すると正確なエイリアス解析を断念します。そのため、`ReturnEscape`は、`%2`（`SafeRef(s)`に対応）と`%20`（`SafeRef(t)`に対応）の両方に課されます。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[]
    push!(ary, SafeRef(s))
    push!(ary, SafeRef(t))
    ary[1], length(ary)
end
```

こうした問題に対処するには、推論で配列の次元を扱い、フロー感度を保って次元情報を伝播する必要があります[^ArrayDimension]。また、ループごとに変化する値を適切に表現する方法も必要です。

現時点で`EscapeAnalysis`は、配列の次元やインデックスが自明に非定数である場合、インデックスの正確な情報を追跡しない、より不正確な解析へすぐに切り替えます。この切り替えは、データフロー解析フレームワークにおける`EscapeInfo.AliasInfo`プロパティの格子結合演算として自然に実装できます。

### [Exception Handling](@id EA-Exception-Handling)

例外を通じたエスケープの可能性を`EscapeAnalysis`がどのように扱うかも、注目に値します。単純に考えると、`:the_exception`オブジェクトに課されたエスケープ情報を、対応する`try`ブロックでスローされる可能性のあるすべての値へ伝播すれば十分に思えます。しかしJuliaでは、`Base.current_exceptions`や`rethrow`など、例外オブジェクトにアクセスする方法がほかにもあります。たとえば、次の例では`r`がエスケープする可能性も、エスケープ解析で考慮する必要があります。

```@repl EAUtils
const GR = Ref{Any}();
@noinline function rethrow_escape!()
    try
        rethrow()
    catch err
        GR[] = err
    end
end;
get′(x) = isassigned(x) ? x[] : throw(x);

code_escapes() do
    r = Ref{String}()
    local t
    try
        t = get′(r)
    catch err
        t = typeof(err)   # `err` (which `r` aliases to) doesn't escape here
        rethrow_escape!() # but `r` escapes here
    end
    return t
end
```

既存の例外インターフェースを通じたエスケープの可能性をすべて正しく推論するには、グローバル解析が必要です。現時点では、スローされる可能性のあるすべてのオブジェクトに、最上位のエスケープ情報を常に保守的に伝播しています。例外処理やエラーパスは通常、性能にそれほど敏感ではなく、エラーパスの最適化も、レイテンシ上の理由から意図的に「最適化されていない」ことが多いため、追加の解析を行う価値は低いと考えられるからです。

`x::EscapeInfo`の`x.ThrownEscape`プロパティは、`x`が例外としてスローされる可能性のあるSSA文を記録します。この情報を使うと、`EscapeAnalysis`は、各`try`領域でスローされる可能性のある値に限って、例外を通じたエスケープを伝播できます。

```@repl EAUtils
result = code_escapes((String,String)) do s1, s2
    r1 = Ref(s1)
    r2 = Ref(s2)
    local ret
    try
        s1 = get′(r1)
        ret = sizeof(s1)
    catch err
        global GV = err # will definitely escape `r1`
    end
    s2 = get′(r2)       # still `r2` doesn't escape fully
    return s2
end
```

## Analysis Usage

`analyze_escapes`は、SSA-IR要素のエスケープ情報を解析するためのエントリポイントです。

SROA（`sroa_pass!`）などの最適化は、インライン化パス（`ssa_inlining_pass!`）がプロシージャ間呼び出しを解決し、呼び出し先のソースを展開して簡素化したソースに適用すると、より効果的です。そのため、`analyze_escapes`はインライン化後のIRも解析でき、特定のメモリ関連最適化に役立つエスケープ情報を収集できます。

ただし、インライン化などの最適化パスは制御フローを変更したり、デッドコードを除去したりするため、エスケープ情報のプロシージャ間での妥当性を損なうことがあります。特に、プロシージャ間で有効なエスケープ情報を収集するには、インライン化前のIRを解析する必要があります。

このため、`analyze_escapes`はJuliaレベルの任意の最適化段階で`IRCode`を解析できます。特に、次の2つの段階で使うことを想定しています。

  * `IPO EA`：インライン化前のIRを解析し、IPOで有効なエスケープ情報のキャッシュを生成する
  * `Local EA`：インライン化後のIRを解析し、ローカルで有効なエスケープ情報を収集する

`IPO EA`から得られたエスケープ情報は、`ArgEscapeCache`データ構造に変換され、グローバルにキャッシュされます。適切な`get_escape_cache`コールバックを`analyze_escapes`に渡すと、以前の`IPO EA`で導出された、インライン化されていない呼び出し先のプロシージャ間情報を利用して、エスケープ解析の精度を高められます。さらに、`IPO EA`のエスケープ情報を型推論に使うこともできます。たとえば、可変オブジェクトの`Const`/`PartialStruct`/`MustAlias`を形成することで、推論精度を高められます。

```@docs
Base.Compiler.EscapeAnalysis.analyze_escapes
Base.Compiler.EscapeAnalysis.EscapeState
Base.Compiler.EscapeAnalysis.EscapeInfo
```

---

[^LatticeDesign]: 型推論の実装では、別の方法を採用しています。各格子プロパティを、専用の格子要素型オブジェクトで表現する方法です。しかし、格子演算の実装が複雑になり始めました。主な理由は、格子要素型オブジェクト間の変換規則が頻繁に必要になることです。現在は、`EscapeInfo`のような格子設計を[overhauling our type inference lattice implementation](https://github.com/JuliaLang/julia/pull/42596)で進めています。

[^MM02]: *A Graph-Free approach to Data-Flow Analysis*. Markas Mohnen、2002年4月。['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'I': ASCII/Unicode U+0049 (category Lu: Letter, uppercase)'D': ASCII/Unicode U+0044 (category Lu: Letter, uppercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'2': ASCII/Unicode U+0032 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)](https://api.semanticscholar.org/CorpusID:28519618)。

[^BackandForth]: これに対して、型推論アルゴリズムは前向き解析として実装されています。型情報は通常「定義」から「使用」へ流れるため、その情報を前向きに伝播するほうが自然で効果的だからです。

[^Dynamism]: ただし、オブジェクトのフィールドを正確に解析できない場合もあります。たとえば、オブジェクトが`EscapeAnalysis`ではそのオブジェクトへのメモリ効果を考慮できない場所へエスケープする場合や、型情報が不足していてオブジェクトのフィールドを特定できない場合です。このような場合、`AliasInfo`プロパティは、それ自体の格子順序における最上位要素まで引き上げられます。その結果、後続のフィールド解析は保守的になり、解析できないオブジェクトのフィールドに課されたエスケープ情報は、そのオブジェクト自体へ伝播します。

[^JVM05]: *Escape Analysis in the Context of Dynamic Compilation and Deoptimization*. Thomas Kotzmann、Hanspeter Mössenböck、2005年6月。['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'7': ASCII/Unicode U+0037 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)](https://dl.acm.org/doi/10.1145/1064979.1064996)。

[^ArrayDimension]: そうしないと、エスケープ解析に加えて、さらに別の前向きデータフロー解析が必要になります。

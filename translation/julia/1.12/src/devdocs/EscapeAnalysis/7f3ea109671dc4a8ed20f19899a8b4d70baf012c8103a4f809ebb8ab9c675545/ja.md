# `EscapeAnalysis`

`Compiler.EscapeAnalysis` は、[Julia's SSA-form IR](@ref Julia-SSA-form-IR)、すなわち `IRCode` のエスケープ情報を分析することを目的としたコンパイラユーティリティモジュールです。

このエスケープ分析の目的は：

  * Juliaの高レベルのセマンティクスを活用し、特に手続き間呼び出しを通じてエスケープとエイリアスについて考察します。
  * さまざまな最適化に使用できるように柔軟である必要があります。これには、[alias-aware SROA](https://github.com/JuliaLang/julia/pull/43888)、[early `finalize` insertion](https://github.com/JuliaLang/julia/pull/44056)、[copy-free `ImmutableArray` construction](https://github.com/JuliaLang/julia/pull/42465)、可変オブジェクトのスタック割り当てなどが含まれます。
  * 単純な実装を達成するために、完全な逆データフロー分析の実装と、直交格子特性を組み合わせた新しい格子設計に基づいています。

## Try it out!

`EAUtils.jl`ユーティリティスクリプトをロードすることで、エスケープ分析を試すことができます。このスクリプトは、テストおよびデバッグ目的のために便利なエントリ`code_escapes`と`@code_escapes`を定義しています。

```@repl EAUtils
# InteractiveUtils.@activate Compiler # to use the stdlib version of the Compiler

let JULIA_DIR = normpath(Sys.BINDIR, "..", "share", "julia")
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

各呼び出し引数およびSSA文の横にある記号は、以下の意味を表します：

  * `◌` (プレーン): この値は分析されません。なぜなら、そのオブジェクトが `isbitstype` の場合など、エスケープ情報は結局使用されないからです。
  * `✓` (緑またはシアン): この値は決して逃げません (`has_no_escape(result.state[x])` が成り立ちます)、引数の逃げがある場合は青色になります (`has_arg_escape(result.state[x])` が成り立ちます)
  * `↑` (青または黄): この値は呼び出し元に戻ることでエスケープすることができます（`has_return_escape(result.state[x])` が成立する場合）、未処理のスローエスケープがある場合は黄色に色付けされます（`has_thrown_escape(result.state[x])` が成立する場合）。
  * `X` (赤): この値は、グローバルメモリへのエスケープのように、エスケープ分析が推論できない場所にエスケープする可能性があります（`has_all_escape(result.state[x])` が成り立ちます）。
  * `*` (太字): この値のエスケープ状態は、`ReturnEscape` と `AllEscape` の間にあり、部分順序の中で [`EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo) にあります。未処理のスローエスケープがある場合は黄色に色付けされます（`has_thrown_escape(result.state[x])` が成立します）。
  * `′`: この値は、その `AliasInfo` プロパティに追加のオブジェクトフィールド / 配列要素情報を持っています。

各呼び出し引数およびSSA値のエスケープ情報は、次のようにプログラム的に検査できます。

```@repl EAUtils
result.state[Core.Argument(3)] # get EscapeInfo of `s2`

result.state[Core.SSAValue(3)] # get EscapeInfo of `r3`
```

## Analysis Design

### Lattice Design

`EscapeAnalysis`は、[data-flow analysis](https://en.wikipedia.org/wiki/Data-flow_analysis)として実装されており、[`x::EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo)の格子で動作します。これは以下のプロパティで構成されています：

  * `x.Analyzed::Bool`: 格子の正式な一部ではなく、単に `x` が分析されていないか、またはそうでないことを示します。
  * `x.ReturnEscape::BitSet`: 呼び出し元に戻ることで `x` がエスケープできる SSA ステートメントを記録します。
  * `x.ThrownEscape::BitSet`: `x` が例外としてスローされる SSA ステートメントを記録します（以下に説明する [exception handling](@ref EA-Exception-Handling) に使用されます）
  * `x.AliasInfo`: `x`のフィールドや配列要素にエイリアスできるすべての可能な値を保持します（以下に説明する[alias analysis](@ref EA-Alias-Analysis)で使用されます）
  * `x.ArgEscape::Int`（まだ実装されていません）：引数を介して`setfield!`で呼び出し元にエスケープすることを示します。

これらの属性は、入力プログラムが有限の文を持つという不変条件がジュリアのセマンティクスによって保証されていることを考慮して、有限の高さを持つ部分格子を作成するために組み合わせることができます。この格子設計の巧妙な部分は、各格子プロパティを個別に処理できるようにすることで、格子操作のより簡単な実装を可能にすることです[^LatticeDesign]。

### Backward Escape Propagation

このエスケープ分析の実装は、論文[^MM02]で説明されているデータフローアルゴリズムに基づいています。この分析は`EscapeInfo`のラティス上で動作し、すべてのラティス要素が収束点に到達するまで、ラティス要素を下から上へ遷移させます。これは、分析対象の残りのSSAステートメントに対応するプログラムカウンタを含む（概念的な）作業セットを維持することによって行われます。この分析は、各引数とSSAステートメントの`EscapeInfo`を追跡する単一のグローバル状態を管理しますが、`EscapeInfo`の`ReturnEscape`プロパティに記録されたプログラムカウンタとしてエンコードされた一部のフロー感度にも注意が必要です。これは、必要に応じて支配分析と組み合わせてフロー感度について推論するために使用できます。

このエスケープ分析の特徴的な設計は、それが完全に *逆方向* であること、すなわちエスケープ情報が *使用から定義へ* 流れることです。例えば、以下のコードスニペットでは、EAは最初にステートメント `return %1` を分析し、`%1`（`obj` に対応）に `ReturnEscape` を課します。そして、次に `%1 = %new(Base.RefValue{Base.RefValue{String}, _2}))` を分析し、`%1` に課された `ReturnEscape` を呼び出し引数 `_2`（`s` に対応）に伝播させます。

```@repl EAUtils
code_escapes((Base.RefValue{String},)) do s
    obj = Ref(s)
    return obj
end
```

ここでの重要な観察は、この逆向きの分析が使用-定義チェーンに沿って自然にエスケープ情報が流れることを可能にするということです[^BackandForth]。その結果、このスキームはエスケープ分析のシンプルな実装を可能にします。例えば、`PhiNode`は、`PhiNode`に課せられたエスケープ情報をその前駆値に伝播させることで簡単に処理できます。

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

`EscapeAnalysis` は、特定の精度でオブジェクトフィールドに課せられたエスケープについて推論するために、逆向きフィールド分析を実装しています。そして、`x::EscapeInfo` の `x.AliasInfo` プロパティはこの目的のために存在します。これは、"使用" サイトで `x` のフィールドにエイリアスされる可能性のあるすべての値を記録し、その後、記録された値のエスケープ情報が "定義" サイトで実際のフィールド値に伝播されます。より具体的には、分析は `getfield` 呼び出しを分析することによってオブジェクトのフィールドにエイリアスされる可能性のある値を記録し、その後、`%new(...)` 式や `setfield!` 呼び出しを分析する際にそのエスケープ情報をフィールドに伝播させます[^Dynamism]。

```@repl EAUtils
code_escapes((String,)) do s
    obj = SafeRef("init")
    obj[] = s
    v = obj[]
    return v
end
```

上記の例では、`ReturnEscape`が`%3`（`v`に対応）に課せられていますが、これは直接`%1`（`obj`に対応）に伝播されるのではなく、`ReturnEscape`は`_2`（`s`に対応）にのみ伝播されます。ここで、`%3`は`%1`の`AliasInfo`プロパティに記録されており、これは`%1`の最初のフィールドにエイリアスされる可能性があるためです。そして、`Base.setfield!(%1, :x, _2)::String`を分析する際に、そのエスケープ情報は`_2`に伝播されますが、`%1`には伝播されません。

`EscapeAnalysis`は、オブジェクトフィールドのエスケープを分析するために、`getfield`-`%new`/`setfield!`チェーンを横断することができるIR要素を追跡しますが、実際にはこのエイリアス分析は他のIR要素も処理できるように一般化する必要があります。これは、JuliaのIRでは同じオブジェクトが異なるIR要素によって表現されることがあるため、実際に同じオブジェクトを表すことができる異なるIR要素が同じエスケープ情報を共有することを確認する必要があるからです。オペランドとして同じオブジェクトを返すIR要素、例えば`PiNode`や`typeassert`は、IRレベルのエイリアシングを引き起こす可能性があり、そのため、エイリアスされた値のいずれかに課せられたエスケープ情報をそれらの間で共有する必要があります。さらに興味深いことに、`PhiNode`の変異について正しく推論するためにも必要です。次の例を考えてみましょう：

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

`ϕ1 = %5` と `ϕ2 = %6` はエイリアスされているため、`ReturnEscape` が `%8 = Base.getfield(%6, :x)::String`（`y = ϕ1[]` に対応）に課せられ、`Base.setfield!(%5, :x, _3)::String`（`ϕ2[] = x` に対応）に伝播する必要があります。このようなエスケープ情報が正しく伝播するためには、分析が `ϕ1` と `ϕ2` の *前駆者* もエイリアスされる可能性があることを認識し、それらのエスケープ情報を等しくする必要があります。

そのようなエイリアス情報の興味深い特性の一つは、それが「使用」サイトでは知られておらず、「定義」サイトでのみ導出できるということです（エイリアスは概念的に代入と同等であるため）、したがって、自然に逆方向の分析には適合しません。関連する値間でエスケープ情報を効率的に伝播させるために、EscapeAnalysis.jlは古いJVM論文で説明されているエスケープ分析アルゴリズムに触発されたアプローチを使用しています[^JVM05]。つまり、エスケープラティス要素を管理することに加えて、分析は「等価」エイリアスセットも維持します。これは、エイリアスされた引数とSSAステートメントの互いに排他的なセットです。エイリアスセットは、お互いにエイリアス可能な値を管理し、エイリアスされた値のいずれかに課せられたエスケープ情報をそれらの間で等しくすることを可能にします。

### [Array Analysis](@id EA-Array-Analysis)

上記で説明したオブジェクトフィールドのエイリアス分析は、配列操作を分析するためにも一般化できます。 `EscapeAnalysis` は、さまざまなプリミティブ配列操作の処理を実装しており、`arrayref`-`arrayset` の使用-定義チェーンを介してエスケープを伝播させ、割り当てられた配列が過度にエスケープしないようにします。

```@repl EAUtils
code_escapes((String,)) do s
    ary = Any[]
    push!(ary, SafeRef(s))
    return ary[1], length(ary)
end
```

上記の例では、`EscapeAnalysis`は`%20`と`%2`（割り当てられたオブジェクト`SafeRef(s)`に対応）が`arrayset`-`arrayref`チェーンを介してエイリアスされていることを理解し、これに`ReturnEscape`を適用しますが、割り当てられた配列`%1`（`ary`に対応）には適用しません。`EscapeAnalysis`は、`ary`が`BoundsError`を介しての潜在的なエスケープを考慮する必要があるため、`ary`に対して`ThrownEscape`を適用しますが、このような未処理の`ThrownEscape`は、`ary`の割り当てを最適化する際に無視されることがよくあります。

さらに、配列インデックス情報と配列の次元が*正確に*わかる場合、`EscapeAnalysis`は`arrayref`-`arrayset`チェーンを介して「要素ごとの」エイリアシングについても推論することができます。これは、`EscapeAnalysis`がオブジェクトに対して「フィールドごとの」エイリアス分析を行うためです。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Vector{Any}(undef, 2)
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

`ReturnEscape`は`%2`（`SafeRef(s)`に対応）にのみ課せられますが、`%4`（`SafeRef(t)`に対応）には課せられません。これは、割り当てられた配列の次元と、すべての`arrayref`/`arrayset`操作に関与するインデックスが定数情報として利用可能であり、`EscapeAnalysis`が`%6`が`%2`にエイリアスされているが、決して`%4`にエイリアスされないことを理解できるからです。このような場合、後続の最適化パスは`Base.arrayref(true, %1, 1)::Any`を`%2`（いわゆる「ロードフォワーディング」）に置き換え、最終的に配列`%1`の割り当てを完全に排除することができます（いわゆる「スカラー置換」）。

オブジェクトフィールド分析と比較すると、オブジェクトフィールドへのアクセスは推論によって得られた型情報を使用して簡単に分析できますが、配列の次元は型情報としてエンコードされていないため、その情報を導き出すために追加の分析が必要です。`EscapeAnalysis`はこの時点で、割り当てられた配列の次元を分析するために追加の単純な線形スキャンを最初に行い、その後、主要な分析ルーチンを起動して、次のエスケープ分析がそれらの配列に対する操作を正確に分析できるようにします。

しかし、そのような正確な「要素ごとの」エイリアス分析はしばしば困難です。本質的に、配列に固有の主な難しさは、配列の次元とインデックスがしばしば定数でないことです：

  * ループはしばしばループ変数、非定数の配列インデックスを生成します。
  * （ベクトルに特有）配列のサイズ変更は配列の次元を変更し、その定数性を無効にします。

具体的な例を挙げて、その困難について話しましょう。

次の例では、`EscapeAnalysis`が正確なエイリアス分析に失敗します。なぜなら、`Base.arrayset(false, %4, %8, %6)::Vector{Any}`のインデックスが（自明に）定数ではないからです。特に、`Any[nothing, nothing]`はループを形成し、そのループ内で`arrayset`操作を呼び出します。このとき、`%6`は制御フローに依存するϕノード値として表されます。その結果、`ReturnEscape`は`%23`（`SafeRef(s)`に対応）と`%25`（`SafeRef(t)`に対応）の両方に課せられますが、理想的には`%23`のみに課せられ、`%25`には課せられないことを望んでいます。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[nothing, nothing]
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

次の例は、ベクターのサイズ変更が正確なエイリアス分析を困難にする様子を示しています。基本的な難しさは、割り当てられた配列 `%1` の次元が最初に `0` として初期化されるが、その後の2回の `:jl_array_grow_end` 呼び出しによって変更されることです。`EscapeAnalysis` は、配列のサイズ変更操作に遭遇すると、正確なエイリアス分析を単純に諦めてしまうため、`%2`（`SafeRef(s)` に対応）と `%20`（`SafeRef(t)` に対応）の両方に `ReturnEscape` が課せられます。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[]
    push!(ary, SafeRef(s))
    push!(ary, SafeRef(t))
    ary[1], length(ary)
end
```

これらの課題に対処するためには、推論が配列の次元を認識し、フローに敏感な方法で配列の次元を伝播させる必要があります[^ArrayDimension]。また、ループ変数の値の良い表現を考案する必要があります。

`EscapeAnalysis` は、配列の次元やインデックスが明らかに定数でない場合に、正確なインデックス情報を追跡しないより不正確な分析に迅速に切り替わります。この切り替えは、データフロー分析フレームワークにおける `EscapeInfo.AliasInfo` プロパティのラティス結合操作として自然に実装できます。

### [Exception Handling](@id EA-Exception-Handling)

`EscapeAnalysis`が例外を介した可能性のあるエスケープをどのように処理するかについても言及する価値があります。単純に考えると、対応する`try`ブロックでスローされる可能性のあるすべての値に対して`:the_exception`オブジェクトに課せられたエスケープ情報を伝播させるだけで十分なように思えます。しかし、実際には、`Base.current_exceptions`や`rethrow`など、Juliaで例外オブジェクトにアクセスするための他のいくつかの方法があります。たとえば、エスケープ分析は、以下の例で`r`の潜在的なエスケープを考慮する必要があります。

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

すべての既存の例外インターフェースを介した可能なエスケープについて正しく推論するには、グローバルな分析が必要です。現時点では、例外処理とエラーパスが通常それほどパフォーマンスに敏感である必要がないことを考慮して、最上位のエスケープ情報をすべての潜在的にスローされるオブジェクトに保守的に伝播させています。また、エラーパスの最適化は、遅延の理由から意図的に「最適化されていない」ことが多いため、非常に効果的でない可能性があります。

`x::EscapeInfo`の`x.ThrownEscape`プロパティは、`x`が例外としてスローされる可能性のあるSSAステートメントを記録します。この情報を使用して、`EscapeAnalysis`は、各`try`領域でスローされる可能性のある例外に限って、例外を介した可能なエスケープを制限的に伝播させることができます。

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

`analyze_escapes`は、SSA-IR要素のエスケープ情報を分析するためのエントリーポイントです。

最適化の多くは、インライン化パス（`ssa_inlining_pass!`）によって手続き間呼び出しが解決され、呼び出し元が展開された最適化されたソースに適用されると、より効果的です。それに応じて、`analyze_escapes`もインライン化後のIRを分析し、特定のメモリ関連の最適化に役立つエスケープ情報を収集することができます。

しかし、インライン化のような特定の最適化パスは制御フローを変更し、デッドコードを排除することができるため、エスケープ情報の手続き間の有効性を破る可能性があります。特に、手続き間で有効なエスケープ情報を収集するためには、インライン化前のIRを分析する必要があります。

この理由から、`analyze_escapes` は任意のJuliaレベルの最適化ステージで `IRCode` を分析でき、特に次の2つのステージで使用されることを意図しています：

  * `IPO EA`: プレインライン前のIRを分析して、IPO有効なエスケープ情報キャッシュを生成します。
  * `Local EA`: インライン後のIRを分析して、ローカルに有効なエスケープ情報を収集します。

`IPO EA`によって得られたエスケープ情報は、`ArgEscapeCache`データ構造に変換され、グローバルにキャッシュされます。適切な`get_escape_cache`コールバックを`analyze_escapes`に渡すことで、エスケープ分析は、以前の`IPO EA`によって得られたインラインされていない呼び出し先のキャッシュされた手続き間情報を利用することで分析精度を向上させることができます。さらに興味深いことに、`IPO EA`のエスケープ情報を型推論に使用することも有効であり、例えば、可変オブジェクトの`Const`/`PartialStruct`/`MustAlias`を形成することで推論精度を向上させることができます。

```@docs
Base.Compiler.EscapeAnalysis.analyze_escapes
Base.Compiler.EscapeAnalysis.EscapeState
Base.Compiler.EscapeAnalysis.EscapeInfo
```

---

[^LatticeDesign]: Our type inference implementation takes the alternative approach, where each lattice property is represented by a special lattice element type object. It turns out that it started to complicate implementations of the lattice operations mainly because it often requires conversion rules between each lattice element type object. And we are working on [overhauling our type inference lattice implementation](https://github.com/JuliaLang/julia/pull/42596) with `EscapeInfo`-like lattice design.

[^MM02]: *A Graph-Free approach to Data-Flow Analysis*.      Markas Mohnen, 2002, April.      [https://api.semanticscholar.org/CorpusID:28519618](https://api.semanticscholar.org/CorpusID:28519618).

[^BackandForth]: Our type inference algorithm in contrast is implemented as a forward analysis, because type information usually flows from "definition" to "usage" and it is more natural and effective to propagate such information in a forward way.

[^Dynamism]: In some cases, however, object fields can't be analyzed precisely. For example, object may escape to somewhere `EscapeAnalysis` can't account for possible memory effects on it, or fields of the objects simply can't be known because of the lack of type information. In such cases `AliasInfo` property is raised to the topmost element within its own lattice order, and it causes succeeding field analysis to be conservative and escape information imposed on fields of an unanalyzable object to be propagated to the object itself.

[^JVM05]: *Escape Analysis in the Context of Dynamic Compilation and Deoptimization*.       Thomas Kotzmann and Hanspeter Mössenböck, 2005, June.       [https://dl.acm.org/doi/10.1145/1064979.1064996](https://dl.acm.org/doi/10.1145/1064979.1064996).

[^ArrayDimension]: Otherwise we will need yet another forward data-flow analysis on top of the escape analysis.

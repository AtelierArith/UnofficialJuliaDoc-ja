# `EscapeAnalysis`

`Compiler.EscapeAnalysis` は、[Julia's SSA-form IR](@ref Julia-SSA-form-IR)（別名 `IRCode`）のエスケープ情報を解析するためのコンパイラユーティリティモジュールです。

このエスケープ解析は、次のことを目指しています。

  * Julia の高水準のセマンティクスを活用し、特に手続き間呼び出しを通じたエスケープやエイリアシングを推論する
  * [alias-aware SROA](https://github.com/JuliaLang/julia/pull/43888)、[early `finalize` insertion](https://github.com/JuliaLang/julia/pull/44056)、[copy-free `ImmutableArray` construction](https://github.com/JuliaLang/julia/pull/42465)、可変オブジェクトのスタック割り当てなど、さまざまな最適化に利用できる汎用性を備える
  * 完全な後向きデータフロー解析と、互いに独立した束の性質を組み合わせる新しい束の設計に基づき、シンプルな実装を実現する

## Try it out!

エスケープ解析を試すには、ユーティリティスクリプト `EAUtils.jl` を読み込みます。このスクリプトは、テストやデバッグに便利なエントリポイント `code_escapes` と `@code_escapes` を定義しています。

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

各呼び出し引数と SSA 文の横にある記号は、次の意味を表します。

  * `◌`（通常表示）：この値のエスケープ情報は使われないため、解析されません（たとえば、オブジェクトが `isbitstype` の場合）。
  * `✓`（緑またはシアン）：この値は決してエスケープしません（`has_no_escape(result.state[x])` が成立）。引数エスケープもある場合（`has_arg_escape(result.state[x])` が成立）は青で表示されます。
  * `↑`（青または黄）：この値は戻り値を通じて呼び出し元にエスケープする可能性があります（`has_return_escape(result.state[x])` が成立）。未処理の例外送出によるエスケープもある場合（`has_thrown_escape(result.state[x])` が成立）は黄で表示されます。
  * `X`（赤）：この値は、グローバルメモリなど、エスケープ解析では推論できない場所にエスケープする可能性があります（`has_all_escape(result.state[x])` が成立）。
  * `*`（太字）：この値のエスケープ状態は、[`EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo) の半順序において `ReturnEscape` と `AllEscape` の間にあります。未処理の例外送出によるエスケープもある場合（`has_thrown_escape(result.state[x])` が成立）は黄で表示されます。
  * `′`：この値の `AliasInfo` プロパティには、オブジェクトのフィールドや配列要素に関する追加情報があります。

各呼び出し引数と SSA 値のエスケープ情報は、次のようにプログラムから調べることができます。

```@repl EAUtils
result.state[Core.Argument(3)] # get EscapeInfo of `s2`

result.state[Core.SSAValue(3)] # get EscapeInfo of `r3`
```

## Analysis Design

### Lattice Design

`EscapeAnalysis` は、[`x::EscapeInfo`](@ref Base.Compiler.EscapeAnalysis.EscapeInfo) の束上で動作する [data-flow analysis](https://en.wikipedia.org/wiki/Data-flow_analysis) として実装されています。この束は、次のプロパティで構成されます。

  * `x.Analyzed::Bool`：厳密には束の一部ではなく、`x` が解析済みかどうかだけを示します。
  * `x.ReturnEscape::BitSet`：`x` が戻り値を通じて呼び出し元にエスケープする可能性のある SSA 文を記録します。
  * `x.ThrownEscape::BitSet`：`x` が例外として送出される可能性のある SSA 文を記録します（後述の [exception handling](@ref EA-Exception-Handling) に使用）。
  * `x.AliasInfo`：`x` のフィールドや配列要素とエイリアス関係になりうる、すべての値を保持します（後述の [alias analysis](@ref EA-Alias-Analysis) に使用）。
  * `x.ArgEscape::Int`（未実装）：引数に対する `setfield!` を通じて、呼び出し元にエスケープすることを示します。

Julia のセマンティクスにより、入力プログラムの文の数は有限であることが保証されます。この不変条件の下で、これらの属性を組み合わせると、高さが有限の半束を構成できます。この束の設計の巧妙な点は、各プロパティを個別に処理できるため、束演算の実装がシンプルになることです[^LatticeDesign]。

### Backward Escape Propagation

このエスケープ解析の実装は、論文[^MM02]で説明されているデータフローアルゴリズムに基づいています。解析は `EscapeInfo` の束上で動作し、すべての束要素が不動点に収束するまで、各要素を最小元から最大元に向かって遷移させます。その際、未解析の SSA 文に対応するプログラムカウンタを含む、概念上の作業集合を管理します。解析では、各引数と SSA 文の `EscapeInfo` を追跡する単一の大域状態を管理します。ただし、`EscapeInfo` の `ReturnEscape` プロパティに記録されたプログラムカウンタには、フロー依存性の一部も符号化されています。必要に応じて、後から支配関係解析と組み合わせることで、フロー依存性を推論できます。

このエスケープ解析の特徴的な設計の一つは、完全に*後向き*であること、つまりエスケープ情報が*使用箇所から定義箇所へ*流れることです。たとえば、以下のコードでは、EA はまず文 `return %1` を解析し、`%1`（`obj` に対応）に `ReturnEscape` を付与します。次に `%1 = %new(Base.RefValue{Base.RefValue{String}, _2}))` を解析し、`%1` に付与された `ReturnEscape` を、呼び出し引数 `_2`（`s` に対応）へ伝播させます。

```@repl EAUtils
code_escapes((Base.RefValue{String},)) do s
    obj = Ref(s)
    return obj
end
```

ここで重要なのは、この後向き解析では、エスケープ情報が制御フローではなく use-def チェーンに沿って自然に流れることです[^BackandForth]。その結果、エスケープ解析をシンプルに実装できます。たとえば `PhiNode` は、`PhiNode` に付与されたエスケープ情報を、その先行値へ伝播させるだけで処理できます。

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

`EscapeAnalysis` は、オブジェクトのフィールドに付与されるエスケープ情報をある程度正確に推論するために、後向きのフィールド解析を実装しています。`x::EscapeInfo` の `x.AliasInfo` プロパティは、このために存在します。このプロパティは、「使用」箇所で `x` のフィールドとエイリアス関係になりうるすべての値を記録し、後で「定義」箇所において、記録された値のエスケープ情報を実際のフィールド値へ伝播させます。具体的には、`getfield` 呼び出しを解析して、オブジェクトのフィールドとエイリアス関係になりうる値を記録します。その後、`%new(...)` 式または `setfield!` 呼び出しを解析するときに、そのエスケープ情報をフィールドへ伝播させます[^Dynamism]。

```@repl EAUtils
code_escapes((String,)) do s
    obj = SafeRef("init")
    obj[] = s
    v = obj[]
    return v
end
```

上の例では、`%3`（`v` に対応）に付与された `ReturnEscape` は、`%1`（`obj` に対応）へ直接伝播される*わけではありません*。代わりに、その `ReturnEscape` は `_2`（`s` に対応）にのみ伝播されます。ここで、`%3` は `%1` の最初のフィールドとエイリアス関係になりうるため、`%1` の `AliasInfo` プロパティに記録されます。その後、`Base.setfield!(%1, :x, _2)::String` を解析すると、そのエスケープ情報は `_2` へ伝播されますが、`%1` へは伝播されません。

このように、`EscapeAnalysis` はオブジェクトのフィールドのエスケープを解析するため、`getfield`-`%new`/`setfield!` チェーンを介して、どの IR 要素がエイリアス関係になりうるかを追跡します。ただし実際には、ほかの IR 要素も扱えるよう、このエイリアス解析を一般化する必要があります。Julia IR では、同じオブジェクトが異なる IR 要素で表されることがあるためです。そのため、実際には同じオブジェクトを表しうる異なる IR 要素が、同じエスケープ情報を共有するようにしなければなりません。`PiNode` や `typeassert` のように、オペランドと同じオブジェクトを返す IR 要素は、このような IR レベルのエイリアシングを生じさせます。したがって、エイリアス関係にある値のいずれかに付与されたエスケープ情報を、それらの値の間で共有する必要があります。さらに興味深いことに、これは `PhiNode` に対する変更を正しく推論するためにも必要です。次の例を考えてみましょう。

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

`ϕ1 = %5` と `ϕ2 = %6` はエイリアス関係にあるため、`%8 = Base.getfield(%6, :x)::String`（`y = ϕ1[]` に対応）に付与された `ReturnEscape` を、`Base.setfield!(%5, :x, _3)::String`（`ϕ2[] = x` に対応）へ伝播させる必要があります。このエスケープ情報を正しく伝播させるには、`ϕ1` と `ϕ2` の*先行値*もエイリアス関係になりうることを認識し、それらのエスケープ情報を同一にする必要があります。

このようなエイリアス情報の興味深い性質の一つは、「使用」箇所では分からず、「定義」箇所でしか導出できないことです。エイリアシングは概念上、代入と等価だからです。そのため、後向き解析には自然に組み込めません。関連する値の間でエスケープ情報を効率的に伝播させるため、EscapeAnalysis.jl は、以前の JVM の論文[^JVM05]で説明されているエスケープ解析アルゴリズムに着想を得た手法を使っています。つまり、エスケープの束要素を管理するだけでなく、エイリアス関係にある引数と SSA 文を互いに素な集合に分けた「equi」エイリアス集合も管理します。このエイリアス集合は、互いにエイリアス関係になりうる値を管理し、そのいずれかに付与されたエスケープ情報を、集合内の値の間で同一にできるようにします。

### [Array Analysis](@id EA-Array-Analysis)

前述のオブジェクトのフィールドに対するエイリアス解析は、配列操作の解析にも一般化できます。`EscapeAnalysis` は、さまざまなプリミティブな配列操作の処理を実装しています。これにより、`arrayref`-`arrayset` の use-def チェーンを通じてエスケープ情報を伝播させ、割り当てられた配列を過度に保守的にエスケープ扱いすることを避けられます。

```@repl EAUtils
code_escapes((String,)) do s
    ary = Any[]
    push!(ary, SafeRef(s))
    return ary[1], length(ary)
end
```

上の例では、`EscapeAnalysis` は、`%20` と `%2`（割り当てられたオブジェクト `SafeRef(s)` に対応）が `arrayset`-`arrayref` チェーンを介してエイリアス関係にあると認識し、それらに `ReturnEscape` を付与します。一方、割り当てられた配列 `%1`（`ary` に対応）には付与しません。ただし、`BoundsError` を通じたエスケープの可能性も考慮する必要があるため、`EscapeAnalysis` は `ary` に `ThrownEscape` を付与します。なお、`ary` の割り当てを最適化するときには、このような未処理の `ThrownEscape` は無視できることがよくあります。

さらに、配列のインデックス情報と各次元のサイズを*正確に*把握できる場合、`EscapeAnalysis` は `arrayref`-`arrayset` チェーンを通じた「要素単位」のエイリアシングまで推論できます。これは、`EscapeAnalysis` がオブジェクトに対して「フィールド単位」のエイリアス解析を行うのと同様です。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Vector{Any}(undef, 2)
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

`ReturnEscape` は `%2`（`SafeRef(s)` に対応）にのみ付与され、`%4`（`SafeRef(t)` に対応）には付与されないことに注目してください。これは、割り当てられた配列の各次元のサイズと、すべての `arrayref`/`arrayset` 操作で使われるインデックスが定数情報として得られるためです。そのため `EscapeAnalysis` は、`%6` が `%2` とエイリアス関係にあり、`%4` とは決してエイリアス関係にならないことを認識できます。このような場合、後続の最適化パスでは `Base.arrayref(true, %1, 1)::Any` を `%2` に置き換え（「load-forwarding」）、最終的に配列 `%1` の割り当てを完全に除去できます（「scalar-replacement」）。

オブジェクトのフィールドへのアクセスは、型推論で得られた型情報を使って容易に解析できます。一方、配列の各次元のサイズは型情報に含まれないため、その情報を得るには追加の解析が必要です。現在の `EscapeAnalysis` は、主解析ルーチンを開始する前に、まず単純な線形走査を追加で行い、割り当てられた配列の各次元のサイズを解析します。これにより、後続のエスケープ解析で、それらの配列に対する操作を正確に解析できます。

ただし、このような正確な「要素単位」のエイリアス解析は、難しいことがよくあります。配列に固有の主な難しさは、本質的には、各次元のサイズやインデックスが定数でないことが多い点にあります。

  * ループでは、ループの反復に伴って変化する非定数の配列インデックスがよく生じます。
  * （ベクトルに特有）配列のサイズ変更により次元のサイズが変わり、定数として扱えなくなります。

これらの難しさを、具体例で見てみましょう。

次の例では、`Base.arrayset(false, %4, %8, %6)::Vector{Any}` のインデックスが（自明には）定数でないため、`EscapeAnalysis` は正確なエイリアス解析を行えません。特に、`Any[nothing, nothing]` はループを形成し、その中で `arrayset` 操作を呼び出します。このとき `%6` は、値が制御フローに依存する ϕ ノードの値として表されます。その結果、`ReturnEscape` は `%23`（`SafeRef(s)` に対応）と `%25`（`SafeRef(t)` に対応）の両方に付与されます。理想的には、`%23` にのみ付与し、`%25` には付与しないようにしたいところです。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[nothing, nothing]
    ary[1] = SafeRef(s)
    ary[2] = SafeRef(t)
    return ary[1], length(ary)
end
```

次の例は、ベクトルのサイズ変更が正確なエイリアス解析を難しくする様子を示しています。本質的な難しさは、割り当てられた配列 `%1` の次元のサイズが、最初は `0` として初期化されるものの、その後の 2 回の `:jl_array_grow_end` 呼び出しで変化することです。現在の `EscapeAnalysis` は、配列のサイズ変更操作を見つけると、その時点で正確なエイリアス解析を断念します。そのため、`ReturnEscape` は `%2`（`SafeRef(s)` に対応）と `%20`（`SafeRef(t)` に対応）の両方に付与されます。

```@repl EAUtils
code_escapes((String,String)) do s, t
    ary = Any[]
    push!(ary, SafeRef(s))
    push!(ary, SafeRef(t))
    ary[1], length(ary)
end
```

これらの難しさに対処するには、型推論が配列の各次元のサイズを認識し、フロー依存の形でその情報を伝播する必要があります[^ArrayDimension]。また、ループの反復に伴って変化する値をうまく表現する方法も必要です。

現在の `EscapeAnalysis` は、配列の各次元のサイズやインデックスが明らかに定数でない場合、正確なインデックス情報を追跡しない、より精度の低い解析へすぐに切り替えます。この切り替えは、データフロー解析の枠組みでは、`EscapeInfo.AliasInfo` プロパティの束の結び演算として自然に実装できます。

### [Exception Handling](@id EA-Exception-Handling)

`EscapeAnalysis` が、例外を通じたエスケープの可能性をどのように扱うかにも触れておきます。単純に考えると、`:the_exception` オブジェクトに付与されたエスケープ情報を、対応する `try` ブロック内で送出されうるすべての値へ伝播させれば十分に思えます。しかし、Julia には `Base.current_exceptions` や `rethrow` など、例外オブジェクトにアクセスする別の方法もあります。たとえば、以下の例では、エスケープ解析は `r` がエスケープする可能性を考慮しなければなりません。

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

既存の例外インターフェースを通じた、あらゆるエスケープの可能性を正しく推論するには、大域的な解析が必要です。現状では、送出される可能性のあるすべてのオブジェクトに対し、常に最大元のエスケープ情報を保守的に伝播させています。通常、例外処理やエラーパスにはそれほど高い性能が求められないため、そのような追加解析を行う価値はないかもしれません。また、エラーパスはレイテンシを抑えるために意図的に「最適化しない」ことも多く、いずれにせよ最適化の効果がきわめて小さい可能性があります。

`x::EscapeInfo` の `x.ThrownEscape` プロパティは、`x` が例外として送出されうる SSA 文を記録します。この情報を使うことで、`EscapeAnalysis` は、例外を通じたエスケープ情報の伝播先を、各 `try` 領域内で送出されうるものだけに限定できます。

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

`analyze_escapes` は、SSA-IR 要素のエスケープ情報を解析するためのエントリポイントです。

SROA（`sroa_pass!`）などの多くの最適化は、インライン化パス（`ssa_inlining_pass!`）が手続き間呼び出しを解決し、呼び出し先のソースを展開して単純化した、最適化済みのソースに適用すると、より効果的です。そのため、`analyze_escapes` はインライン化後の IR も解析し、特定のメモリ関連の最適化に役立つエスケープ情報を収集できます。

しかし、インライン化などの最適化パスは制御フローを変更したり、デッドコードを除去したりするため、エスケープ情報の手続き間での妥当性を損なうことがあります。したがって、手続き間で有効なエスケープ情報を収集するには、インライン化前の IR を解析する必要があります。

このため、`analyze_escapes` は、Julia レベルの最適化のどの段階でも `IRCode` を解析できます。特に、次の 2 つの段階での使用を想定しています。

  * `IPO EA`：インライン化前の IR を解析し、IPO で有効なエスケープ情報のキャッシュを生成します。
  * `Local EA`：インライン化後の IR を解析し、局所的に有効なエスケープ情報を収集します。

`IPO EA` によって得られたエスケープ情報は、`ArgEscapeCache` データ構造に変換され、大域的にキャッシュされます。`analyze_escapes` に適切な `get_escape_cache` コールバックを渡すと、エスケープ解析は、以前の `IPO EA` で得られた、インライン化されていない呼び出し先の手続き間情報のキャッシュを活用し、解析精度を高められます。さらに興味深いことに、`IPO EA` のエスケープ情報を型推論に使うこともできます。たとえば、可変オブジェクトの `Const`/`PartialStruct`/`MustAlias` を構成することで、推論精度を高められます。

```@docs
Base.Compiler.EscapeAnalysis.analyze_escapes
Base.Compiler.EscapeAnalysis.EscapeState
Base.Compiler.EscapeAnalysis.EscapeInfo
```

---

[^LatticeDesign]: 私たちの型推論の実装は、各束プロパティを専用の束要素型オブジェクトで表す、別の手法を採用しています。しかし、この手法では、束要素型オブジェクト間の変換規則が必要になることが多く、主にそのために束演算の実装が複雑になってきました。そこで、`EscapeInfo` に似た束の設計を用いる [overhauling our type inference lattice implementation](https://github.com/JuliaLang/julia/pull/42596) に取り組んでいます。

[^MM02]: *A Graph-Free approach to Data-Flow Analysis*.      Markas Mohnen、2002 年 4 月。      ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'I': ASCII/Unicode U+0049 (category Lu: Letter, uppercase)'D': ASCII/Unicode U+0044 (category Lu: Letter, uppercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'2': ASCII/Unicode U+0032 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)](https://api.semanticscholar.org/CorpusID:28519618)。

[^BackandForth]: 対照的に、私たちの型推論アルゴリズムは前向き解析として実装されています。型情報は通常「定義」から「使用」へ流れるため、前向きに伝播させる方が自然で効果的だからです。

[^Dynamism]: ただし、オブジェクトのフィールドを正確に解析できない場合もあります。たとえば、`EscapeAnalysis` ではメモリへの影響を考慮できない場所にオブジェクトがエスケープする場合や、型情報が不足していて、そもそもオブジェクトのフィールドが分からない場合です。このような場合、`AliasInfo` プロパティは、その固有の束の順序における最大元まで引き上げられます。その結果、後続のフィールド解析は保守的になり、解析できないオブジェクトのフィールドに付与されたエスケープ情報は、オブジェクト自体へ伝播されます。

[^JVM05]: *Escape Analysis in the Context of Dynamic Compilation and Deoptimization*.       Thomas Kotzmann および Hanspeter Mössenböck、2005 年 6 月。       ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'7': ASCII/Unicode U+0037 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)](https://dl.acm.org/doi/10.1145/1064979.1064996)。

[^ArrayDimension]: そうしなければ、エスケープ解析に加えて、別の前向きデータフロー解析が必要になります。

# Methods

[Functions](@ref man-functions)から思い出してください。関数は、引数のタプルを戻り値にマッピングするオブジェクトであり、適切な値を返すことができない場合は例外をスローします。同じ概念的な関数や操作が、異なるタイプの引数に対して非常に異なる方法で実装されることは一般的です。2つの整数を加算することは、2つの浮動小数点数を加算することとは非常に異なり、どちらも整数と浮動小数点数を加算することとは異なります。これらの実装の違いにもかかわらず、これらの操作はすべて「加算」という一般的な概念に属します。したがって、Juliaでは、これらの動作はすべて単一のオブジェクトに属します：`+`関数です。

異なる実装をスムーズに使用するためには、関数は一度にすべて定義する必要はなく、特定の引数の型と数の組み合わせに対して特定の動作を提供することで、部分的に定義することができます。関数の可能な動作の定義は*メソッド*と呼ばれます。これまで、すべての引数の型に適用可能な単一のメソッドで定義された関数の例のみを示してきました。しかし、メソッド定義のシグネチャには、数に加えて引数の型を示す注釈を付けることができ、単一のメソッド定義だけでなく、複数のメソッド定義を提供することもできます。関数が特定の引数のタプルに適用されると、その引数に適用可能な最も特異なメソッドが適用されます。したがって、関数の全体的な動作は、そのさまざまなメソッド定義の動作のパッチワークとなります。このパッチワークがうまく設計されていれば、メソッドの実装がかなり異なっていても、関数の外部の動作はシームレスで一貫しているように見えるでしょう。

関数が適用されるときにどのメソッドを実行するかの選択を*ディスパッチ*と呼びます。Juliaは、ディスパッチプロセスが与えられた引数の数と関数のすべての引数の型に基づいて、呼び出すべき関数のメソッドを選択できるようにします。これは、ディスパッチが最初の引数のみに基づいて行われる従来のオブジェクト指向言語とは異なります。従来の言語では、最初の引数は特別な引数構文を持っていることが多く、時には明示的に引数として書かれるのではなく、暗黙的に示されることがあります。[^1] 関数のすべての引数を使用して、最初の引数だけでなく、どのメソッドを呼び出すべきかを選択することは、[multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch)として知られています。複数のディスパッチは、数学的なコードに特に便利であり、操作が「どの引数に属する」と人工的に決定することはほとんど意味がありません。`x + y`の加算操作は、`x`に属するのか、`y`に属するのか、どちらでしょうか？数学的演算子の実装は、一般的にそのすべての引数の型に依存します。しかし、数学的な操作を超えて、複数のディスパッチはプログラムを構造化し、整理するための強力で便利なパラダイムとなります。

[^1]: In C++ or Java, for example, in a method call like `obj.meth(arg1,arg2)`, the object obj "receives" the method call and is implicitly passed to the method via the `this` keyword, rather than as an explicit method argument. When the current `this` object is the receiver of a method call, it can be omitted altogether, writing just `meth(arg1,arg2)`, with `this` implied as the receiving object.

!!! note
    この章のすべての例は、*同じ* モジュール内の関数にメソッドを定義していると仮定しています。*別の* モジュールの関数にメソッドを追加したい場合は、それを `import` するか、モジュール名で修飾された名前を使用する必要があります。[namespace management](@ref namespace-management) のセクションを参照してください。


## Defining Methods

これまでの例では、制約のない引数型を持つ単一のメソッドを持つ関数のみを定義してきました。このような関数は、従来の動的型付け言語と同様に動作します。それにもかかわらず、私たちはほとんど意識せずに複数のディスパッチとメソッドを使用してきました。前述の `+` 関数のように、Juliaの標準関数や演算子は、さまざまな引数型と数の組み合わせに対する動作を定義する多くのメソッドを持っています。

関数を定義する際、`::` 型アサーション演算子を使用して、適用可能なパラメータの型をオプションで制約することができます。この演算子は、[Composite Types](@ref) のセクションで導入されました。

```jldoctest fofxy
julia> f(x::Float64, y::Float64) = 2x + y
f (generic function with 1 method)
```

この関数定義は、`x` と `y` の両方がタイプ [`Float64`](@ref) の値である呼び出しにのみ適用されます:

```jldoctest fofxy
julia> f(2.0, 3.0)
7.0
```

他のタイプの引数に適用すると、[`MethodError`](@ref) になります:

```jldoctest fofxy
julia> f(2.0, 3)
ERROR: MethodError: no method matching f(::Float64, ::Int64)
The function `f` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  f(::Float64, !Matched::Float64)
   @ Main none:1

Stacktrace:
[...]

julia> f(Float32(2.0), 3.0)
ERROR: MethodError: no method matching f(::Float32, ::Float64)
The function `f` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  f(!Matched::Float64, ::Float64)
   @ Main none:1

Stacktrace:
[...]

julia> f(2.0, "3.0")
ERROR: MethodError: no method matching f(::Float64, ::String)
The function `f` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  f(::Float64, !Matched::Float64)
   @ Main none:1

Stacktrace:
[...]

julia> f("2.0", "3.0")
ERROR: MethodError: no method matching f(::String, ::String)
The function `f` exists, but no method is defined for this combination of argument types.
```

ご覧のとおり、引数は正確に型 [`Float64`](@ref) でなければなりません。他の数値型、例えば整数や32ビット浮動小数点値は自動的に64ビット浮動小数点に変換されることはなく、文字列が数値として解析されることもありません。`Float64` は具体的な型であり、具体的な型はJuliaでサブクラス化できないため、そのような定義は正確に型 `Float64` の引数にのみ適用できます。しかし、宣言されたパラメータ型が抽象であるより一般的なメソッドを書くことはしばしば有用です。

```jldoctest fofxy
julia> f(x::Number, y::Number) = 2x - y
f (generic function with 2 methods)

julia> f(2.0, 3)
1.0
```

このメソッド定義は、[`Number`](@ref) のインスタンスである任意の引数のペアに適用されます。同じ型である必要はなく、それぞれが数値であれば問題ありません。異なる数値型を扱う問題は、式 `2x - y` の算術演算に委ねられます。

複数のメソッドを持つ関数を定義するには、異なる数とタイプの引数を持つ関数を複数回定義するだけです。関数の最初のメソッド定義は関数オブジェクトを作成し、その後のメソッド定義は既存の関数オブジェクトに新しいメソッドを追加します。引数の数とタイプに最も特異的なメソッド定義が、関数が適用されるときに実行されます。したがって、上記の2つのメソッド定義は、抽象型`Number`のすべてのインスタンスのペアに対する`f`の動作を定義しますが、[`Float64`](@ref)値のペアに特有の異なる動作を持っています。引数の1つが64ビット浮動小数点数で、もう1つがそうでない場合、`f(Float64,Float64)`メソッドは呼び出すことができず、より一般的な`f(Number,Number)`メソッドを使用しなければなりません。

```jldoctest fofxy
julia> f(2.0, 3.0)
7.0

julia> f(2, 3.0)
1.0

julia> f(2.0, 3)
1.0

julia> f(2, 3)
1
```

The `2x + y` definition is only used in the first case, while the `2x - y` definition is used in the others. No automatic casting or conversion of function arguments is ever performed: all conversion in Julia is non-magical and completely explicit. [Conversion and Promotion](@ref conversion-and-promotion), however, shows how clever application of sufficiently advanced technology can be indistinguishable from magic. [^Clarke61]

非数値の値や、引数が2つ未満または2つ以上の場合、関数 `f` は未定義のままであり、それを適用すると依然として [`MethodError`](@ref) になります:

```jldoctest fofxy
julia> f("foo", 3)
ERROR: MethodError: no method matching f(::String, ::Int64)
The function `f` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  f(!Matched::Number, ::Number)
   @ Main none:1
  f(!Matched::Float64, !Matched::Float64)
   @ Main none:1

Stacktrace:
[...]

julia> f()
ERROR: MethodError: no method matching f()
The function `f` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  f(!Matched::Float64, !Matched::Float64)
   @ Main none:1
  f(!Matched::Number, !Matched::Number)
   @ Main none:1

Stacktrace:
[...]
```

関数オブジェクト自体をインタラクティブセッションに入力することで、その関数に存在するメソッドを簡単に確認できます：

```jldoctest fofxy
julia> f
f (generic function with 2 methods)
```

この出力は、`f` が2つのメソッドを持つ関数オブジェクトであることを示しています。それらのメソッドのシグネチャを見つけるには、[`methods`](@ref) 関数を使用します：

```jldoctest fofxy
julia> methods(f)
# 2 methods for generic function "f" from Main:
 [1] f(x::Float64, y::Float64)
     @ none:1
 [2] f(x::Number, y::Number)
     @ none:1
```

`f`には2つのメソッドがあり、1つは2つの`Float64`引数を取り、もう1つは`Number`型の引数を取ることを示しています。また、メソッドが定義されたファイルと行番号も示しています。これらのメソッドはREPLで定義されたため、見かけ上の行番号は`none:1`となります。

型宣言が `::` なしで存在しない場合、メソッドパラメータの型はデフォルトで `Any` となり、すべての値が抽象型 `Any` のインスタンスであるため、制約がありません。したがって、次のように `f` のキャッチオールメソッドを定義できます:

```jldoctest fofxy
julia> f(x,y) = println("Whoa there, Nelly.")
f (generic function with 3 methods)

julia> methods(f)
# 3 methods for generic function "f" from Main:
 [1] f(x::Float64, y::Float64)
     @ none:1
 [2] f(x::Number, y::Number)
     @ none:1
 [3] f(x, y)
     @ none:1

julia> f("foo", 1)
Whoa there, Nelly.
```

このキャッチオールは、パラメータ値のペアに対する他の可能なメソッド定義よりも具体性が低いため、他のメソッド定義が適用されない引数のペアに対してのみ呼び出されます。

第三のメソッドのシグネチャには、引数 `x` と `y` の型が指定されていないことに注意してください。これは `f(x::Any, y::Any)` を表現する短縮形です。

値の型に基づく複数ディスパッチは、一見単純な概念のように思えますが、ジュリア言語の最も強力で中心的な機能の一つです。コア操作は通常、数十のメソッドを持っています：

```julia-repl
julia> methods(+)
# 180 methods for generic function "+":
[1] +(x::Bool, z::Complex{Bool}) in Base at complex.jl:227
[2] +(x::Bool, y::Bool) in Base at bool.jl:89
[3] +(x::Bool) in Base at bool.jl:86
[4] +(x::Bool, y::T) where T<:AbstractFloat in Base at bool.jl:96
[5] +(x::Bool, z::Complex) in Base at complex.jl:234
[6] +(a::Float16, b::Float16) in Base at float.jl:373
[7] +(x::Float32, y::Float32) in Base at float.jl:375
[8] +(x::Float64, y::Float64) in Base at float.jl:376
[9] +(z::Complex{Bool}, x::Bool) in Base at complex.jl:228
[10] +(z::Complex{Bool}, x::Real) in Base at complex.jl:242
[11] +(x::Char, y::Integer) in Base at char.jl:40
[12] +(c::BigInt, x::BigFloat) in Base.MPFR at mpfr.jl:307
[13] +(a::BigInt, b::BigInt, c::BigInt, d::BigInt, e::BigInt) in Base.GMP at gmp.jl:392
[14] +(a::BigInt, b::BigInt, c::BigInt, d::BigInt) in Base.GMP at gmp.jl:391
[15] +(a::BigInt, b::BigInt, c::BigInt) in Base.GMP at gmp.jl:390
[16] +(x::BigInt, y::BigInt) in Base.GMP at gmp.jl:361
[17] +(x::BigInt, c::Union{UInt16, UInt32, UInt64, UInt8}) in Base.GMP at gmp.jl:398
...
[180] +(a, b, c, xs...) in Base at operators.jl:424
```

複数ディスパッチと柔軟なパラメトリック型システムが組み合わさることで、Juliaは実装の詳細から切り離された高レベルのアルゴリズムを抽象的に表現する能力を持っています。

## [Method specializations](@id man-method-specializations)

複数のメソッドを同じ関数に作成する場合、これは時々「特化」と呼ばれます。この場合、追加のメソッドを追加することで*関数*を特化しています：各新しいメソッドは関数の新しい特化です。上記に示すように、これらの特化は`methods`によって返されます。

プログラマーの介入なしに発生する別の種類の特化があります：Juliaのコンパイラは、使用される特定の引数型に対して*メソッド*を自動的に特化させることができます。このような特化は`methods`によってリストされることはなく、これは新しい`Method`を作成しないためですが、[`@code_typed`](@ref)のようなツールを使用すると、そのような特化を検査することができます。

例えば、メソッドを作成する場合

```
mysum(x::Real, y::Real) = x + y
```

あなたは関数 `mysum` に新しいメソッド（おそらく唯一のメソッド）を与え、そのメソッドは任意のペアの `Real` 数値入力を受け取ります。しかし、その後に実行すると

```julia-repl
julia> mysum(1, 2)
3

julia> mysum(1.0, 2.0)
3.0
```

Juliaは`mysum`を2回コンパイルします。1回目は`x::Int, y::Int`用、2回目は`x::Float64, y::Float64`用です。2回コンパイルする目的はパフォーマンスです。`mysum`が使用する`+`の呼び出されるメソッドは、`x`と`y`の特定の型によって異なり、異なる特殊化をコンパイルすることで、Juliaは事前にすべてのメソッドルックアップを行うことができます。これにより、プログラムは実行中にメソッドルックアップを気にする必要がなくなり、はるかに迅速に実行されます。Juliaの自動特殊化により、汎用アルゴリズムを書くことができ、コンパイラが必要な各ケースを処理するために効率的で特殊化されたコードを生成することを期待できます。

潜在的な専門分野の数が実質的に無限である場合、Juliaはこのデフォルトの専門化を回避することがあります。詳細については [Be aware of when Julia avoids specializing](@ref) を参照してください。

## [Method Ambiguities](@id man-ambiguities)

特定の引数の組み合わせに対して、一意の最も特定的なメソッドが適用されないような関数メソッドのセットを定義することは可能です：

```jldoctest gofxy
julia> g(x::Float64, y) = 2x + y
g (generic function with 1 method)

julia> g(x, y::Float64) = x + 2y
g (generic function with 2 methods)

julia> g(2.0, 3)
7.0

julia> g(2, 3.0)
8.0

julia> g(2.0, 3.0)
ERROR: MethodError: g(::Float64, ::Float64) is ambiguous.

Candidates:
  g(x, y::Float64)
    @ Main none:1
  g(x::Float64, y)
    @ Main none:1

Possible fix, define
  g(::Float64, ::Float64)

Stacktrace:
[...]
```

ここで、呼び出し `g(2.0, 3.0)` は、`g(::Float64, ::Any)` または `g(::Any, ::Float64)` メソッドのいずれかによって処理される可能性があります。メソッドが定義される順序は重要ではなく、どちらも他のメソッドよりも特異的ではありません。このような場合、Juliaは任意のメソッドを選択するのではなく、[`MethodError`](@ref) を発生させます。交差ケースに対して適切なメソッドを指定することで、メソッドの曖昧さを回避できます：

```jldoctest gofxy
julia> g(x::Float64, y::Float64) = 2x + 2y
g (generic function with 3 methods)

julia> g(2.0, 3)
7.0

julia> g(2, 3.0)
8.0

julia> g(2.0, 3.0)
10.0
```

まず、曖昧さを解消する方法を定義することが推奨されます。そうしないと、より具体的な方法が定義されるまで、曖昧さが一時的に存在するからです。

より複雑なケースでは、メソッドの曖昧さを解決するには、ある程度の設計要素が関与します。このトピックはさらに探求されています [below](@ref man-method-design-ambiguities)。

## Parametric Methods

メソッド定義は、署名を修飾する型パラメータをオプションで持つことができます：

```jldoctest same_typefunc
julia> same_type(x::T, y::T) where {T} = true
same_type (generic function with 1 method)

julia> same_type(x,y) = false
same_type (generic function with 2 methods)
```

最初のメソッドは、両方の引数が同じ具体的な型である場合に適用され、型が何であれ関係ありません。一方、2番目のメソッドは、すべての他のケースをカバーするキャッチオールとして機能します。したがって、全体として、これは2つの引数が同じ型であるかどうかをチェックするブール関数を定義します：

```jldoctest same_typefunc
julia> same_type(1, 2)
true

julia> same_type(1, 2.0)
false

julia> same_type(1.0, 2.0)
true

julia> same_type("foo", 2.0)
false

julia> same_type("foo", "bar")
true

julia> same_type(Int32(1), Int64(2))
false
```

そのような定義は、`UnionAll` 型の型シグネチャを持つメソッドに対応しています（[UnionAll Types](@ref)を参照）。

このような関数の動作をディスパッチによって定義することは、Juliaでは非常に一般的で、慣用的です。メソッドの型パラメータは、引数の型として使用されることに制限されず、関数のシグネチャや関数の本体で値が必要な場所であればどこでも使用できます。以下は、メソッドの型パラメータ `T` がメソッドシグネチャのパラメトリック型 `Vector{T}` の型パラメータとして使用される例です：

```jldoctest
julia> function myappend(v::Vector{T}, x::T) where {T}
           return [v..., x]
       end
myappend (generic function with 1 method)
```

型パラメータ `T` は、この例において追加される要素 `x` がベクター `v` の既存の eltype のサブタイプであることを保証します。`where` キーワードは、メソッドシグネチャの定義の後にこれらの制約のリストを導入します。これは、上記のように1行の定義でも同様に機能し、もし存在する場合は、以下に示すように [return type declaration](@ref man-functions-return-type) の *前* に現れなければなりません。

```jldoctest
julia> (myappend(v::Vector{T}, x::T)::Vector) where {T} = [v..., x]
myappend (generic function with 1 method)

julia> myappend([1,2,3],4)
4-element Vector{Int64}:
 1
 2
 3
 4

julia> myappend([1,2,3],2.5)
ERROR: MethodError: no method matching myappend(::Vector{Int64}, ::Float64)
The function `myappend` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  myappend(::Vector{T}, !Matched::T) where T
   @ Main none:1

Stacktrace:
[...]

julia> myappend([1.0,2.0,3.0],4.0)
4-element Vector{Float64}:
 1.0
 2.0
 3.0
 4.0

julia> myappend([1.0,2.0,3.0],4)
ERROR: MethodError: no method matching myappend(::Vector{Float64}, ::Int64)
The function `myappend` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  myappend(::Vector{T}, !Matched::T) where T
   @ Main none:1

Stacktrace:
[...]
```

追加された要素の型が追加先のベクターの要素型と一致しない場合、[`MethodError`](@ref) が発生します。次の例では、メソッドの型パラメータ `T` が戻り値として使用されています：

```jldoctest
julia> mytypeof(x::T) where {T} = T
mytypeof (generic function with 1 method)

julia> mytypeof(1)
Int64

julia> mytypeof(1.0)
Float64
```

型宣言において型パラメータにサブタイプ制約を付けることができるのと同様に（[Parametric Types](@ref)を参照）、メソッドの型パラメータにも制約を付けることができます：

```jldoctest
julia> same_type_numeric(x::T, y::T) where {T<:Number} = true
same_type_numeric (generic function with 1 method)

julia> same_type_numeric(x::Number, y::Number) = false
same_type_numeric (generic function with 2 methods)

julia> same_type_numeric(1, 2)
true

julia> same_type_numeric(1, 2.0)
false

julia> same_type_numeric(1.0, 2.0)
true

julia> same_type_numeric("foo", 2.0)
ERROR: MethodError: no method matching same_type_numeric(::String, ::Float64)
The function `same_type_numeric` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  same_type_numeric(!Matched::T, ::T) where T<:Number
   @ Main none:1
  same_type_numeric(!Matched::Number, ::Number)
   @ Main none:1

Stacktrace:
[...]

julia> same_type_numeric("foo", "bar")
ERROR: MethodError: no method matching same_type_numeric(::String, ::String)
The function `same_type_numeric` exists, but no method is defined for this combination of argument types.

julia> same_type_numeric(Int32(1), Int64(2))
false
```

`same_type_numeric` 関数は、上で定義された `same_type` 関数と非常に似た動作をしますが、数値のペアにのみ定義されています。

パラメトリックメソッドは、型を書くために使用される `where` 式と同じ構文を許可します（[UnionAll Types](@ref) を参照）。パラメータが1つだけの場合、囲む波括弧（`where {T}`）は省略できますが、明確さのために好まれることが多いです。複数のパラメータはカンマで区切ることができ、例えば `where {T, S<:Real}` のように書くことができます。また、ネストされた `where` を使用して書くこともでき、例えば `where S<:Real where T` のようになります。

## Redefining Methods

メソッドを再定義したり新しいメソッドを追加したりする際には、これらの変更がすぐには反映されないことを理解することが重要です。これは、Juliaがコードを静的に推論し、迅速に実行するためにコンパイルする能力の鍵となります。通常のJITトリックやオーバーヘッドなしで。実際、新しいメソッド定義は、現在のランタイム環境、タスクやスレッド（および以前に定義された`@generated`関数を含む）には表示されません。これが何を意味するのかを理解するために、例を見てみましょう。

```julia-repl
julia> function tryeval()
           @eval newfun() = 1
           newfun()
       end
tryeval (generic function with 1 method)

julia> tryeval()
ERROR: MethodError: no method matching newfun()
The applicable method may be too new: running in world age xxxx1, while current world is xxxx2.
Closest candidates are:
  newfun() at none:1 (method too new to be called from this world context.)
 in tryeval() at none:1
 ...

julia> newfun()
1
```

この例では、`newfun`の新しい定義が作成されたことに注意してくださいが、すぐには呼び出すことができません。新しいグローバルは`tryeval`関数にすぐに見えるため、`return newfun`（括弧なし）と書くことができます。しかし、あなたも、あなたの呼び出し元も、また彼らが呼び出す関数も、この新しいメソッド定義を呼び出すことはできません！

しかし、例外があります：`newfun`への将来の呼び出しは*REPLから*期待通りに動作し、新しい定義の`newfun`を見て呼び出すことができます。

しかし、将来の`tryeval`への呼び出しは、`newfun`の定義を*REPLの前のステートメントでの状態*として見ることになり、そのため`tryeval`への呼び出しの前になります。

自分でこれを試して、どのように機能するかを確認したいかもしれません。

この動作の実装は「ワールドエイジカウンター」であり、これは [Worldage](@ref man-worldage) マニュアルの章でさらに説明されています。

## Design Patterns with Parametric Methods

複雑なディスパッチロジックは、パフォーマンスや使いやすさのために必須ではありませんが、時には特定のアルゴリズムを表現する最良の方法となることがあります。ここでは、この方法でディスパッチを使用する際に時々見られるいくつかの一般的なデザインパターンを紹介します。

### Extracting the type parameter from a super-type

ここに、要素型 `T` を返すための正しいコードテンプレートがあります。これは、明確に定義された要素型を持つ任意の `AbstractArray` のサブタイプに適用できます。

```julia
abstract type AbstractArray{T, N} end
eltype(::Type{<:AbstractArray{T}}) where {T} = T
```

いわゆる三角ディスパッチを使用しています。`UnionAll` 型、例えば `eltype(AbstractArray{T} where T <: Integer)` は、上記のメソッドには一致しません。このような場合に備えて、`Base` の `eltype` の実装は `Any` に対するフォールバックメソッドを追加します。

一般的な間違いの一つは、イントロスペクションを使用して要素の型を取得しようとすることです：

```julia
eltype_wrong(::Type{A}) where {A<:AbstractArray} = A.parameters[1]
```

しかし、これが失敗するケースを構築するのは難しくありません：

```julia
struct BitVector <: AbstractArray{Bool, 1}; end
```

ここでは、パラメータがない型 `BitVector` を作成しましたが、要素型は完全に指定されており、`T` は `Bool` に等しいです！

もう一つの間違いは、`supertype`を使って型階層を上がろうとすることです:

```julia
eltype_wrong(::Type{AbstractArray{T}}) where {T} = T
eltype_wrong(::Type{AbstractArray{T, N}}) where {T, N} = T
eltype_wrong(::Type{A}) where {A<:AbstractArray} = eltype_wrong(supertype(A))
```

宣言された型にはこれが機能しますが、スーパタイプを持たない型には失敗します:

```julia-repl
julia> eltype_wrong(Union{Vector{Int}, Matrix{Int}})
ERROR: MethodError: no method matching supertype(::Type{VecOrMat{Int64}})

Closest candidates are:
  supertype(::UnionAll)
   @ Base operators.jl:44
  supertype(::DataType)
   @ Base operators.jl:43
```

### Building a similar type with a different type parameter

汎用コードを構築する際には、型のレイアウトに変更を加えた類似のオブジェクトを構築する必要があることがよくあります。これには型パラメータの変更も必要です。たとえば、任意の要素型を持つ抽象配列があり、特定の要素型でその上で計算を行いたい場合があります。この型変換をどのように計算するかを説明するメソッドを各 `AbstractArray{T}` サブタイプに実装する必要があります。異なるパラメータを持つ別のサブタイプへの一般的な変換は存在しません。

`AbstractArray`のサブタイプは、通常、これを達成するために2つのメソッドを実装します。1つは、入力配列を特定の`AbstractArray{T, N}`抽象型のサブタイプに変換するメソッドであり、もう1つは、特定の要素型を持つ新しい未初期化配列を作成するメソッドです。これらのサンプル実装はJulia Baseにあります。以下は、`input`と`output`が同じ型であることを保証する基本的な使用例です：

```julia
input = convert(AbstractArray{Eltype}, input)
output = similar(input, Eltype)
```

この延長として、アルゴリズムが入力配列のコピーを必要とする場合、[`convert`](@ref) は不十分です。なぜなら、戻り値が元の入力とエイリアスする可能性があるからです。出力配列を作成するための [`similar`](@ref) と、入力データでそれを埋めるための [`copyto!`](@ref) を組み合わせることは、入力引数の可変コピーの要件を表現する一般的な方法です。

```julia
copy_with_eltype(input, Eltype) = copyto!(similar(input, Eltype), input)
```

### Iterated dispatch

マルチレベルのパラメトリック引数リストをディスパッチするためには、各ディスパッチレベルを異なる関数に分けるのが最良であることが多いです。これはシングルディスパッチのアプローチに似ているように聞こえるかもしれませんが、以下で見ていくように、依然としてより柔軟です。

例えば、配列の要素タイプに基づいてディスパッチしようとすると、しばしば曖昧な状況に直面します。代わりに、一般的なコードは最初にコンテナタイプに基づいてディスパッチし、その後 `eltype` に基づいてより具体的なメソッドに再帰します。ほとんどの場合、アルゴリズムはこの階層的アプローチに便利に適応しますが、他の場合には、この厳密さを手動で解決する必要があります。このディスパッチの分岐は、例えば、2つの行列を合計するロジックにおいて観察できます：

```julia
# First dispatch selects the map algorithm for element-wise summation.
+(a::Matrix, b::Matrix) = map(+, a, b)
# Then dispatch handles each element and selects the appropriate
# common element type for the computation.
+(a, b) = +(promote(a, b)...)
# Once the elements have the same type, they can be added.
# For example, via primitive operations exposed by the processor.
+(a::Float64, b::Float64) = Core.add(a, b)
```

### Trait-based dispatch

反復ディスパッチの自然な拡張は、型階層によって定義されたセットとは独立した型のセットに基づいてディスパッチを行うメソッド選択のレイヤーを追加することです。このようなセットは、問題の型の `Union` を書き出すことで構築できますが、その場合、このセットは拡張可能ではなく、`Union` 型は作成後に変更できないためです。しかし、このような拡張可能なセットは、しばしば ["Holy-trait"](https://github.com/JuliaLang/julia/issues/2345#issuecomment-54537633) と呼ばれるデザインパターンを使用してプログラムできます。

このパターンは、関数引数が属する可能性のある各トレイトセットに対して異なるシングルトン値（または型）を計算する汎用関数を定義することによって実装されます。この関数が純粋であれば、通常のディスパッチと比較してパフォーマンスに影響はありません。

前のセクションの例では、[`map`](@ref) と [`promote`](@ref) の実装の詳細が省略されており、これらはこれらの特性に基づいて動作します。行列を反復処理する際、例えば `map` の実装において、データをトラバースするためにどの順序を使用するかは重要な質問です。`AbstractArray` のサブタイプが [`Base.IndexStyle`](@ref) 特性を実装すると、`map` のような他の関数はこの情報に基づいて最適なアルゴリズムを選択することができます（[Abstract Array Interface](@ref man-interface-array) を参照）。これは、各サブタイプが `map` のカスタムバージョンを実装する必要がないことを意味し、一般的な定義 + 特性クラスにより、システムが最も速いバージョンを選択できるようになります。以下は、特性ベースのディスパッチを示す `map` のおもちゃの実装です：

```julia
map(f, a::AbstractArray, b::AbstractArray) = map(Base.IndexStyle(a, b), f, a, b)
# generic implementation:
map(::Base.IndexCartesian, f, a::AbstractArray, b::AbstractArray) = ...
# linear-indexing implementation (faster)
map(::Base.IndexLinear, f, a::AbstractArray, b::AbstractArray) = ...
```

この特性ベースのアプローチは、スカラー `+` によって使用される [`promote`](@ref) メカニズムにも存在します。これは [`promote_type`](@ref) を使用しており、オペランドの2つの型に基づいて操作を計算するための最適な共通型を返します。これにより、すべての可能な型引数のペアに対してすべての関数を実装するという問題を、各型から共通型への変換操作を実装するというはるかに小さな問題と、好ましいペアワイズ昇格ルールのテーブルに還元することが可能になります。

### Output-type computation

トレイトベースのプロモーションに関する議論は、次のデザインパターンへの移行を提供します：行列演算の出力要素タイプを計算することです。

原始操作を実装するために、加算などの操作を行うために、[`promote_type`](@ref) 関数を使用して、望ましい出力タイプを計算します。（以前と同様に、`+` への呼び出しの中で `promote` 呼び出しでこれを見ました）。

より複雑な行列の関数に対しては、より複雑な操作のシーケンスに対する期待される戻り値の型を計算する必要がある場合があります。これは通常、以下のステップによって実行されます：

1. Write a small function `op` that expresses the set of operations performed by the kernel of the algorithm.
2. 結果行列の要素型 `R` を `promote_op(op, argument_types...)` として計算します。ここで、`argument_types` は各入力配列に対して `eltype` を適用して計算されます。
3. 出力行列を `similar(R, dims)` として構築します。ここで、`dims` は出力配列の希望する次元です。

より具体的な例として、一般的な正方行列の乗算の擬似コードは次のようになります：

```julia
function matmul(a::AbstractMatrix, b::AbstractMatrix)
    op = (ai, bi) -> ai * bi + ai * bi

    ## this is insufficient because it assumes `one(eltype(a))` is constructable:
    # R = typeof(op(one(eltype(a)), one(eltype(b))))

    ## this fails because it assumes `a[1]` exists and is representative of all elements of the array
    # R = typeof(op(a[1], b[1]))

    ## this is incorrect because it assumes that `+` calls `promote_type`
    ## but this is not true for some types, such as Bool:
    # R = promote_type(ai, bi)

    # this is wrong, since depending on the return value
    # of type-inference is very brittle (as well as not being optimizable):
    # R = Base.return_types(op, (eltype(a), eltype(b)))

    ## but, finally, this works:
    R = promote_op(op, eltype(a), eltype(b))
    ## although sometimes it may give a larger type than desired
    ## it will always give a correct type

    output = similar(b, R, (size(a, 1), size(b, 2)))
    if size(a, 2) > 0
        for j in 1:size(b, 2)
            for i in 1:size(a, 1)
                ## here we don't use `ab = zero(R)`,
                ## since `R` might be `Any` and `zero(Any)` is not defined
                ## we also must declare `ab::R` to make the type of `ab` constant in the loop,
                ## since it is possible that typeof(a * b) != typeof(a * b + a * b) == R
                ab::R = a[i, 1] * b[1, j]
                for k in 2:size(a, 2)
                    ab += a[i, k] * b[k, j]
                end
                output[i, j] = ab
            end
        end
    end
    return output
end
```

### Separate convert and kernel logic

コンパイル時間とテストの複雑さを大幅に削減する方法の一つは、目的の型への変換と計算のロジックを分離することです。これにより、コンパイラは大きなカーネルの本体から独立して変換ロジックを特化させ、インライン化することができます。

これは、アルゴリズムによって実際にサポートされている特定の引数型に、より大きな型のクラスから変換する際に見られる一般的なパターンです。

```julia
complexfunction(arg::Int) = ...
complexfunction(arg::Any) = complexfunction(convert(Int, arg))

matmul(a::T, b::T) = ...
matmul(a, b) = matmul(promote(a, b)...)
```

## Parametrically-constrained Varargs methods

関数のパラメータは、「varargs」関数に供給できる引数の数を制約するためにも使用できます（[Varargs Functions](@ref)）。このような制約を示すために、`Vararg{T,N}`という表記が使用されます。例えば：

```jldoctest
julia> bar(a,b,x::Vararg{Any,2}) = (a,b,x)
bar (generic function with 1 method)

julia> bar(1,2,3)
ERROR: MethodError: no method matching bar(::Int64, ::Int64, ::Int64)
The function `bar` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  bar(::Any, ::Any, ::Any, !Matched::Any)
   @ Main none:1

Stacktrace:
[...]

julia> bar(1,2,3,4)
(1, 2, (3, 4))

julia> bar(1,2,3,4,5)
ERROR: MethodError: no method matching bar(::Int64, ::Int64, ::Int64, ::Int64, ::Int64)
The function `bar` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  bar(::Any, ::Any, ::Any, ::Any)
   @ Main none:1

Stacktrace:
[...]
```

より有用なのは、パラメータによって varargs メソッドを制約することが可能であることです。例えば：

```julia
function getindex(A::AbstractArray{T,N}, indices::Vararg{Number,N}) where {T,N}
```

`indices`の数が配列の次元数と一致する場合にのみ呼び出されます。

引数の型を制約する必要がある場合、`Vararg{T}`は`T...`として同等に書くことができます。例えば、`f(x::Int...) = x`は`f(x::Vararg{Int}) = x`の短縮形です。

## Note on Optional and keyword Arguments

[Functions](@ref man-functions)で簡単に触れたように、オプションの引数は複数のメソッド定義の構文として実装されています。例えば、この定義：

```julia
f(a=1,b=2) = a+2b
```

次の3つの方法に翻訳します：

```julia
f(a,b) = a+2b
f(a) = f(a,2)
f() = f(1,2)
```

これは、`f()`を呼び出すことが`f(1,2)`を呼び出すことと同等であることを意味します。この場合、結果は`5`です。なぜなら、`f(1,2)`は上記の`f`の最初のメソッドを呼び出すからです。しかし、これは常にそうである必要はありません。整数に特化した第四のメソッドを定義した場合：

```julia
f(a::Int,b::Int) = a-2b
```

そのため、`f()` と `f(1,2)` の両方の結果は `-3` です。言い換えれば、オプション引数は関数に結び付けられており、その関数の特定のメソッドには結び付けられていません。どのメソッドが呼び出されるかは、オプション引数の型によって決まります。オプション引数がグローバル変数に基づいて定義されている場合、オプション引数の型は実行時に変更されることさえあります。

キーワード引数は、通常の位置引数とはかなり異なる動作をします。特に、メソッドのディスパッチには参加しません。メソッドは位置引数のみに基づいてディスパッチされ、キーワード引数は一致するメソッドが特定された後に処理されます。

## Function-like objects

メソッドは型に関連付けられているため、型にメソッドを追加することで任意のJuliaオブジェクトを「呼び出し可能」にすることができます。（このような「呼び出し可能」なオブジェクトは時々「ファンクタ」と呼ばれます。）

例えば、多項式の係数を格納する型を定義できますが、多項式を評価する関数のように振る舞います:

```jldoctest polynomial
julia> struct Polynomial{R}
           coeffs::Vector{R}
       end

julia> function (p::Polynomial)(x)
           v = p.coeffs[end]
           for i = (length(p.coeffs)-1):-1:1
               v = v*x + p.coeffs[i]
           end
           return v
       end

julia> (p::Polynomial)() = p(5)
```

関数は名前ではなく型によって指定されていることに注意してください。通常の関数と同様に、簡潔な構文形式があります。関数の本体では、`p`は呼び出されたオブジェクトを参照します。`Polynomial`は次のように使用できます：

```jldoctest polynomial
julia> p = Polynomial([1,10,100])
Polynomial{Int64}([1, 10, 100])

julia> p(3)
931

julia> p()
2551
```

このメカニズムは、Juliaにおける型コンストラクタとクロージャ（周囲の環境を参照する内部関数）がどのように機能するかの鍵でもあります。

## Empty generic functions

時折、メソッドを追加せずに汎用関数を導入することが有用です。これは、インターフェース定義と実装を分離するために使用できます。また、ドキュメントやコードの可読性のために行われることもあります。これを行うための構文は、引数のタプルなしの空の `function` ブロックです：

```julia
function emptyfunc end
```

## [Method design and the avoidance of ambiguities](@id man-method-design-ambiguities)

Juliaのメソッドの多態性は、その最も強力な特徴の一つですが、この力を活用することは設計上の課題を引き起こすことがあります。特に、より複雑なメソッド階層では、[ambiguities](@ref man-ambiguities)が発生することは珍しくありません。

上記では、曖昧さを解消する方法が指摘されました。

```julia
f(x, y::Int) = 1
f(x::Int, y) = 2
```

メソッドを定義することによって

```julia
f(x::Int, y::Int) = 3
```

これはしばしば正しい戦略ですが、このアドバイスを無思考で従うことが逆効果になる状況もあります。特に、汎用関数のメソッドが多ければ多いほど、あいまいさの可能性が増えます。この単純な例よりもメソッド階層が複雑になると、代替戦略について慎重に考える価値があるかもしれません。

以下では、特定の課題とそれらの問題を解決するためのいくつかの代替方法について議論します。

### Tuple and NTuple arguments

`Tuple`（および `NTuple`）の引数は特別な課題を提示します。例えば、

```julia
f(x::NTuple{N,Int}) where {N} = 1
f(x::NTuple{N,Float64}) where {N} = 2
```

は曖昧です。`N == 0` の可能性があるため、`Int` または `Float64` のバリアントが呼び出されるべきかを判断する要素がありません。この曖昧さを解決するための一つのアプローチは、空のタプルに対してメソッドを定義することです。

```julia
f(x::Tuple{}) = 3
```

代わりに、1つの方法を除いて、タプルに少なくとも1つの要素があることを主張できます：

```julia
f(x::NTuple{N,Int}) where {N} = 1           # this is the fallback
f(x::Tuple{Float64, Vararg{Float64}}) = 2   # this requires at least one Float64
```

### [Orthogonalize your design](@id man-methods-orthogonalize)

2つ以上の引数でディスパッチすることを検討している場合は、「ラッパー」関数を使用することで、よりシンプルな設計になるかもしれません。たとえば、複数のバリアントを書く代わりに:

```julia
f(x::A, y::A) = ...
f(x::A, y::B) = ...
f(x::B, y::A) = ...
f(x::B, y::B) = ...
```

あなたは定義を考慮するかもしれません

```julia
f(x::A, y::A) = ...
f(x, y) = f(g(x), g(y))
```

ここで `g` は引数を型 `A` に変換します。これは、より一般的な原則 [orthogonal design](https://en.wikipedia.org/wiki/Orthogonality_(programming)) の非常に特定の例であり、別々の概念が別々のメソッドに割り当てられます。ここで、`g` はおそらくフォールバック定義が必要になります。

```julia
g(x::A) = x
```

関連する戦略は、`promote`を利用して`x`と`y`を共通の型に持ってくることです：

```julia
f(x::T, y::T) where {T} = ...
f(x, y) = f(promote(x, y)...)
```

このデザインのリスクの一つは、`x` と `y` を同じ型に変換する適切なプロモーション方法がない場合、2 番目のメソッドが自分自身を無限に再帰し、スタックオーバーフローを引き起こす可能性があることです。

### Dispatch on one argument at a time

複数の引数でディスパッチする必要があり、実用的にすべての可能なバリアントを定義するには組み合わせが多すぎる場合は、最初の引数でディスパッチし、その後内部メソッドを呼び出す「名前カスケード」を導入することを検討してください。

```julia
f(x::A, y) = _fA(x, y)
f(x::B, y) = _fB(x, y)
```

その後、内部メソッド `_fA` と `_fB` は、`x` に関して互いに曖昧さを気にすることなく `y` に基づいてディスパッチできます。

この戦略には少なくとも1つの大きな欠点があることに注意してください。多くの場合、ユーザーはエクスポートされた関数 `f` の動作をさらにカスタマイズするために、追加の特殊化を定義することができません。代わりに、ユーザーは内部メソッド `_fA` と `_fB` の特殊化を定義しなければならず、これによりエクスポートされたメソッドと内部メソッドの境界が曖昧になります。

### Abstract containers and element types

可能な限り、抽象コンテナの特定の要素タイプに基づいてディスパッチするメソッドの定義を避けるようにしてください。例えば、

```julia
-(A::AbstractArray{T}, b::Date) where {T<:Date}
```

メソッドを定義する人にとってあいまいさを生じさせます。

```julia
-(A::MyArrayType{T}, b::T) where {T}
```

最良いアプローチは、これらのメソッドの*いずれ*も定義しないことです。代わりに、汎用メソッド `-(A::AbstractArray, b)` に依存し、このメソッドが各コンテナタイプと要素タイプに対して*別々に*正しいことを行う汎用呼び出し（`similar` や `-` のような）で実装されていることを確認してください。これは、あなたのメソッドを [orthogonalize](@ref man-methods-orthogonalize) するというアドバイスのより複雑なバリアントに過ぎません。

このアプローチが不可能な場合、他の開発者と曖昧さを解決するための議論を始める価値があるかもしれません。最初に定義されたメソッドがあるからといって、それが修正されたり排除されたりできないわけではありません。最後の手段として、1人の開発者が「バンドエイド」メソッドを定義することができます。

```julia
-(A::MyArrayType{T}, b::Date) where {T<:Date} = ...
```

それは力任せで曖昧さを解消します。

### Complex method "cascades" with default arguments

デフォルトを提供するメソッド「cascade」を定義する場合、潜在的なデフォルトに対応する引数を省略しないように注意してください。たとえば、デジタルフィルタリングアルゴリズムを書いていて、信号のエッジを処理するためにパディングを適用するメソッドがあるとします：

```julia
function myfilter(A, kernel, ::Replicate)
    Apadded = replicate_edges(A, size(kernel))
    myfilter(Apadded, kernel)  # now perform the "real" computation
end
```

これはデフォルトのパディングを提供するメソッドに反することになります：

```julia
myfilter(A, kernel) = myfilter(A, kernel, Replicate()) # replicate the edge by default
```

これら2つの方法は、`A`が常に大きくなり続ける無限再帰を生成します。

より良いデザインは、コール階層を次のように定義することです：

```julia
struct NoPad end  # indicate that no padding is desired, or that it's already applied

myfilter(A, kernel) = myfilter(A, kernel, Replicate())  # default boundary conditions

function myfilter(A, kernel, ::Replicate)
    Apadded = replicate_edges(A, size(kernel))
    myfilter(Apadded, kernel, NoPad())  # indicate the new boundary conditions
end

# other padding methods go here

function myfilter(A, kernel, ::NoPad)
    # Here's the "real" implementation of the core computation
end
```

`NoPad` は、他の種類のパディングと同じ引数の位置に供給されるため、ディスパッチ階層を適切に整理し、あいまいさの可能性を減らします。さらに、"public" `myfilter` インターフェースを拡張します：パディングを明示的に制御したいユーザーは、`NoPad` バリアントを直接呼び出すことができます。

## Defining methods in local scope

[local scope](@ref scope-of-variables) 内でメソッドを定義できます。例えば、

```jldoctest
julia> function f(x)
           g(y::Int) = y + x
           g(y) = y - x
           g
       end
f (generic function with 1 method)

julia> h = f(3);

julia> h(4)
7

julia> h(4.0)
1.0
```

しかし、ローカルメソッドを条件付きで定義したり、制御フローに従ったりしてはいけません。

```julia
function f2(inc)
    if inc
        g(x) = x + 1
    else
        g(x) = x - 1
    end
end

function f3()
    function g end
    return g
    g() = 0
end
```

それがどの関数が最終的に定義されるか明確でないため、将来的にはこの方法でローカルメソッドを定義することがエラーになる可能性があります。

このような場合は、代わりに無名関数を使用してください:

```julia
function f2(inc)
    g = if inc
        x -> x + 1
    else
        x -> x - 1
    end
end
```

[^Clarke61]: Arthur C. Clarke, *Profiles of the Future* (1961): Clarke's Third Law.

# Methods

[Functions](@ref man-functions)で説明したように、関数とは、引数のタプルを戻り値に対応付けるオブジェクトです。適切な値を返せない場合は、例外をスローします。同じ概念上の関数や演算でも、引数の型によって実装が大きく異なることはよくあります。たとえば、整数同士の加算は浮動小数点数同士の加算とは大きく異なり、整数と浮動小数点数の加算とも異なります。実装はそれぞれ異なりますが、これらの演算はいずれも「加算」という一般的な概念に属します。したがってJuliaでは、これらの振る舞いはすべて単一のオブジェクト、すなわち`+`関数に属します。

同じ概念に対するさまざまな実装をスムーズに利用できるようにするため、関数の定義は一度にまとめて行う必要はありません。引数の型と個数の特定の組み合わせに対する振る舞いを指定し、段階的に定義できます。関数が取りうる振る舞いの定義を、*メソッド*と呼びます。これまで紹介したのは、あらゆる型の引数に適用できる単一のメソッドを持つ関数の例だけでした。しかし、メソッド定義のシグネチャには、引数の個数だけでなく型も指定できます。また、複数のメソッド定義を用意することもできます。特定の引数タプルに関数を適用すると、その引数に適用可能なメソッドのうち、最も具体的なものが実行されます。つまり、関数全体の振る舞いは、さまざまなメソッド定義の振る舞いを組み合わせたものです。この組み合わせが適切に設計されていれば、メソッドの実装が大きく異なっていても、関数の外から見た振る舞いは一貫していて、継ぎ目のないものになります。

関数を適用したときにどのメソッドを実行するかを選ぶ仕組みを、*ディスパッチ*と呼びます。Juliaでは、与えられた引数の個数と、関数のすべての引数の型に基づいて、呼び出すメソッドを選択できます。これは、最初の引数だけに基づいてディスパッチする従来のオブジェクト指向言語とは異なります。そうした言語では、最初の引数に特別な構文が使われることが多く、引数として明示的に書かずに暗黙に渡される場合もあります。[^1] 最初の引数だけでなく関数のすべての引数を使って呼び出すメソッドを選ぶことを、[multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch)と呼びます。多重ディスパッチは、特に数学的なコードで役立ちます。演算がほかの引数よりも特定の引数に「属する」と人為的に見なすのは、あまり意味がないからです。たとえば、`x + y`の加算演算は、`x`に属する度合いが、`y`に属する度合いより高いのでしょうか。数学演算の実装は、一般にすべての引数の型に依存します。しかし、多重ディスパッチは数学演算に限らず、プログラムを構成・整理するための強力で便利なパラダイムです。

[^1]: たとえばC++やJavaでは、`obj.meth(arg1,arg2)`のようなメソッド呼び出しで、オブジェクトobjがメソッド呼び出しを「受け取り」、`this`キーワードを介して暗黙にメソッドへ渡されます。明示的なメソッド引数として渡されるわけではありません。現在の`this`オブジェクトがメソッド呼び出しの受け手である場合は、そのオブジェクトを完全に省略して`meth(arg1,arg2)`とだけ書けます。このとき、受け手のオブジェクトは`this`であると暗黙に見なされます。

!!! note
    この章の例はすべて、同じモジュール内の関数にメソッドを定義することを前提としています。*別の*モジュールにある関数へメソッドを追加する場合は、その関数を`import`するか、モジュール名で修飾した名前を使う必要があります。詳しくは[namespace management](@ref namespace-management)の節を参照してください。


## Defining Methods

これまでの例では、引数の型に制約のない単一のメソッドを持つ関数だけを定義してきました。このような関数は、従来の動的型付け言語での関数と同じように振る舞います。それでも、私たちは意識しないまま、ほぼ常に多重ディスパッチとメソッドを使ってきました。前述の`+`関数をはじめ、Juliaの標準関数や演算子には、引数の型と個数のさまざまな組み合わせに対する振る舞いを定義するメソッドが多数あります。

関数を定義するときは、`::`型アサーション演算子を使って、その関数を適用できる引数の型を任意で制約できます。この演算子については、[Composite Types](@ref)の節で紹介しました。

```jldoctest fofxy
julia> f(x::Float64, y::Float64) = 2x + y
f (generic function with 1 method)
```

この関数定義が適用されるのは、`x`と`y`がどちらも[`Float64`](@ref)型の値である場合に限られます。

```jldoctest fofxy
julia> f(2.0, 3.0)
7.0
```

それ以外の型の引数を渡すと、[`MethodError`](@ref)になります。

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

ご覧のとおり、引数は厳密に[`Float64`](@ref)型でなければなりません。整数や32ビット浮動小数点数など、ほかの数値型が64ビット浮動小数点数に自動変換されることはなく、文字列が数値として解析されることもありません。`Float64`は具象型であり、Juliaでは具象型をサブクラス化できないため、この定義が適用されるのは、引数が厳密に`Float64`型である場合だけです。ただし、宣言する引数の型を抽象型にして、より汎用的なメソッドを書くと便利なこともよくあります。

```jldoctest fofxy
julia> f(x::Number, y::Number) = 2x - y
f (generic function with 2 methods)

julia> f(2.0, 3)
1.0
```

このメソッド定義は、[`Number`](@ref)のインスタンスである任意の引数ペアに適用されます。どちらも数値であればよく、同じ型である必要はありません。異なる数値型を扱う処理は、式`2x - y`内の算術演算に委ねられます。

複数のメソッドを持つ関数を定義するには、引数の個数や型を変えて、その関数を複数回定義します。関数に対する最初のメソッド定義によって関数オブジェクトが作成され、それ以降のメソッド定義は既存の関数オブジェクトに新しいメソッドを追加します。関数を適用すると、引数の個数と型に一致するメソッド定義のうち、最も具体的なものが実行されます。したがって、上記の2つのメソッド定義を合わせると、抽象型`Number`のインスタンスのあらゆるペアに対する`f`の振る舞いが定義されます。ただし、[`Float64`](@ref)値のペアには、固有の振る舞いが適用されます。一方の引数が64ビット浮動小数点数で、もう一方がそうでない場合は、`f(Float64,Float64)`メソッドを呼び出せないため、より汎用的な`f(Number,Number)`メソッドが使われます。

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

`2x + y`の定義が使われるのは最初のケースだけで、それ以外では`2x - y`の定義が使われます。関数の引数が自動的にキャストまたは変換されることはありません。Juliaでの変換はすべて、魔法のように行われるのではなく、完全に明示的です。ただし、[Conversion and Promotion](@ref conversion-and-promotion)は、十分に高度な技術を巧みに使えば、魔法と見分けがつかなくなることを示しています。[^Clarke61]

数値以外の値を渡した場合や、引数が2個より少ない、または多い場合は、関数`f`は未定義のままなので、適用すると[`MethodError`](@ref)になります。

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

対話セッションで関数オブジェクト自体を入力すると、その関数に存在するメソッドを簡単に確認できます。

```jldoctest fofxy
julia> f
f (generic function with 2 methods)
```

この出力から、`f`が2つのメソッドを持つ関数オブジェクトだと分かります。それぞれのメソッドのシグネチャを確認するには、[`methods`](@ref)関数を使います。

```jldoctest fofxy
julia> methods(f)
# 2 methods for generic function "f" from Main:
 [1] f(x::Float64, y::Float64)
     @ none:1
 [2] f(x::Number, y::Number)
     @ none:1
```

この出力から、`f`には2つのメソッドがあり、一方は`Float64`型の引数を2つ取り、もう一方は`Number`型の引数を取ることが分かります。また、メソッドが定義されたファイルと行番号も示されます。これらのメソッドはREPLで定義したため、行番号は`none:1`と表示されます。

`::`による型宣言がない場合、メソッドの引数の型はデフォルトで`Any`です。Juliaのすべての値は抽象型`Any`のインスタンスなので、これは型に制約がないことを意味します。したがって、`f`に対する、あらゆる引数ペアを受け付けるメソッドを次のように定義できます。

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

この汎用メソッドは、引数の値のペアに対して定義できるほかのどのメソッドよりも具体性が低いため、ほかのメソッド定義が適用されない引数ペアに対してのみ呼び出されます。

3つ目のメソッドのシグネチャでは、引数`x`と`y`の型が指定されていないことに注意してください。これは`f(x::Any, y::Any)`を短く書いたものです。

単純な概念に見えますが、値の型に基づく多重ディスパッチは、おそらくJulia言語の機能の中で最も強力かつ中心的なものです。基本的な演算には、通常、数十ものメソッドがあります。

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

多重ディスパッチと柔軟なパラメトリック型システムを組み合わせることで、Juliaでは実装の詳細から切り離して、高水準のアルゴリズムを抽象的に表現できます。

## [Method specializations](@id man-method-specializations)

同じ関数に複数のメソッドを作成することを、「特殊化」と呼ぶことがあります。この場合は、関数にメソッドを追加して*関数*を特殊化しています。新しいメソッドを追加するたびに、その関数の新たな特殊化が作られます。上で示したように、こうした特殊化は`methods`によって返されます。

プログラマーが介入しなくても行われる、もう一つの種類の特殊化があります。Juliaのコンパイラーは、実際に使われる引数の型に合わせて、*メソッド*を自動的に特殊化できます。このような特殊化は`methods`には表示されません。新しい`Method`が作られるわけではないためです。ただし、[`@code_typed`](@ref)などのツールを使えば、こうした特殊化を調べられます。

たとえば、次のメソッドを作成したとします。

```jldoctest mysum_example; output = false
mysum(x::Real, y::Real) = x + y

# output

mysum (generic function with 1 method)
```

これにより、関数`mysum`に新しいメソッドが1つ追加されます（これが唯一のメソッドである場合もあります）。このメソッドは、`Real`型の数値入力を2つ受け取ります。その後、次を実行すると、

```jldoctest mysum_example
julia> mysum(1, 2)
3

julia> mysum(1.0, 2.0)
3.0
```

Juliaは`mysum`を2回コンパイルします。1回目は`x::Int, y::Int`用、2回目は`x::Float64, y::Float64`用です。2回コンパイルするのは、性能を高めるためです。`+`に対して呼び出されるメソッド（`mysum`が使うメソッド）は、`x`と`y`の具体的な型によって異なります。異なる特殊化をコンパイルしておけば、Juliaはメソッド検索をあらかじめ済ませられます。そのため、実行中にメソッド検索を行う必要がなくなり、プログラムを大幅に高速化できます。Juliaの自動特殊化を利用すれば、汎用的なアルゴリズムを書くだけで、コンパイラーが必要なケースごとに効率的な特殊化コードを生成してくれます。

特殊化の候補数が実質的に無制限になりうる場合、Juliaはデフォルトの特殊化を行わないことがあります。詳しくは[Be aware of when Julia avoids specializing](@ref)を参照してください。

## [Method Ambiguities](@id man-ambiguities)

関数のメソッドを、ある引数の組み合わせに対して適用できる最も具体的なメソッドが一意に定まらないように定義することもできます。

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

この場合、呼び出し`g(2.0, 3.0)`には、`g(::Float64, ::Any)`メソッドと`g(::Any, ::Float64)`メソッドのどちらも適用できます。メソッドを定義した順序は関係なく、どちらか一方が他方より具体的ということもありません。このような場合、Juliaは任意にメソッドを選ぶのではなく、[`MethodError`](@ref)を発生させます。交差するケースに適切なメソッドを定義すれば、メソッドの曖昧さを回避できます。

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

曖昧さを解消するメソッドは、先に定義しておくことをお勧めします。そうしないと、より具体的なメソッドを定義するまでの間、一時的とはいえ曖昧さが存在するためです。

より複雑なケースでは、メソッドの曖昧さを解消するために設計上の工夫が必要になります。このトピックについては、[below](@ref man-method-design-ambiguities)でさらに説明します。

## Parametric Methods

メソッド定義では、シグネチャを修飾する型パラメーターを任意で指定できます。

```jldoctest same_typefunc
julia> same_type(x::T, y::T) where {T} = true
same_type (generic function with 1 method)

julia> same_type(x,y) = false
same_type (generic function with 2 methods)
```

最初のメソッドは、2つの引数が同じ具象型であれば、その型が何であっても適用されます。2つ目のメソッドは、それ以外のすべてのケースを受け付ける汎用メソッドです。したがって、全体としては、2つの引数が同じ型かどうかを判定する真偽値関数が定義されます。

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

このような定義は、型シグネチャが`UnionAll`型であるメソッドに対応します（[UnionAll Types](@ref)を参照）。

ディスパッチによって関数の振る舞いを定義するこの方法は、Juliaでは非常によく使われる、いわば慣用的な書き方です。メソッドの型パラメーターは、引数の型として使う場合に限られません。関数のシグネチャや本体で値を使える場所なら、どこでも使えます。次の例では、メソッドのシグネチャにあるパラメトリック型`Vector{T}`の型パラメーターとして、メソッドの型パラメーター`T`を使っています。

```jldoctest
julia> function myappend(v::Vector{T}, x::T) where {T}
           return [v..., x]
       end
myappend (generic function with 1 method)
```

この例の型パラメーター`T`により、追加する要素`x`は、ベクター`v`の既存の要素型のサブタイプであることが保証されます。`where`キーワードは、メソッドシグネチャの定義の後に制約のリストを導入します。これは、上記のような1行の定義でも同様に機能します。また、以下に示すように、[return type declaration](@ref man-functions-return-type)がある場合は、その前に置く必要があります。

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

追加する要素の型が、追加先のベクターの要素型と一致しない場合は、[`MethodError`](@ref)が発生します。次の例では、メソッドの型パラメーター`T`を戻り値として使っています。

```jldoctest
julia> mytypeof(x::T) where {T} = T
mytypeof (generic function with 1 method)

julia> mytypeof(1)
Int64

julia> mytypeof(1.0)
Float64
```

型宣言の型パラメーターにサブタイプ制約を付けられるのと同様に（[Parametric Types](@ref)を参照）、メソッドの型パラメーターにも制約を付けられます。

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

`same_type_numeric`関数は、上で定義した`same_type`関数とよく似た振る舞いをしますが、数値のペアに対してのみ定義されています。

パラメトリックメソッドでは、型を書くときに使う`where`式と同じ構文を使えます（[UnionAll Types](@ref)を参照）。パラメーターが1つだけの場合は、囲みの波括弧（`where {T}`）を省略できますが、明確さのために付けることもよくあります。複数のパラメーターは、たとえば`where {T, S<:Real}`のようにコンマで区切るか、`where`を入れ子にして、たとえば`where S<:Real where T`のように書けます。

## Redefining Methods

メソッドを再定義したり、新しいメソッドを追加したりしても、その変更がすぐに反映されるわけではないことに注意してください。これは、通常のJITの仕組みやオーバーヘッドに頼らず、Juliaがコードを静的に推論・コンパイルして高速に実行できるようにするうえで重要です。実際、新しいメソッド定義は、現在の実行環境からは見えません。これには、タスクやスレッド、すでに定義されている`@generated`関数も含まれます。まず例を見て、どういうことか確認しましょう。

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

この例では、`newfun`の新しい定義が作成されているものの、すぐには呼び出せないことに注目してください。新しいグローバル変数は`tryeval`関数からすぐに見えるため、括弧を付けずに`return newfun`と書くことはできます。しかし、あなた自身も、呼び出し元も、その関数が呼び出す関数も、その他のどの関数も、この新しいメソッド定義を呼び出すことはできません。

ただし例外があります。*REPLから*行う`newfun`の今後の呼び出しは、期待どおりに動作し、`newfun`の新しい定義を参照して呼び出せます。

一方、`tryeval`の今後の呼び出しでは、`newfun`の定義は、*REPLで直前の文を実行した時点*のままです。そのため、その呼び出しより前に行われた`tryeval`の定義は見えません。

実際に試して、動作を確認してみてください。

この動作は「ワールドエイジカウンター」によって実現されています。詳しくは、マニュアルの[World Age](@ref World-age-in-general)の章で説明しています。

## Design Patterns with Parametric Methods

複雑なディスパッチロジックは、性能や使いやすさのために必須ではありません。しかし、アルゴリズムを表現するうえで最適な方法となることもあります。ここでは、ディスパッチをこのように使う際によく見られる設計パターンをいくつか紹介します。

### Extracting the type parameter from a super-type

要素型が明確に定義されている`AbstractArray`の任意のサブタイプについて、その要素型`T`を返す正しいコードのひな型は、次のとおりです。

```julia
abstract type AbstractArray{T, N} end
eltype(::Type{<:AbstractArray{T}}) where {T} = T
```

これは、いわゆる三角ディスパッチを使っています。たとえば`eltype(AbstractArray{T} where T <: Integer)`のような`UnionAll`型は、上記のメソッドには一致しないことに注意してください。`Base`にある`eltype`の実装では、このようなケースに対応するフォールバックメソッドを`Any`に追加しています。

よくある間違いの一つは、イントロスペクションを使って要素型を取得しようとすることです。

```julia
eltype_wrong(::Type{A}) where {A<:AbstractArray} = A.parameters[1]
```

しかし、この方法が失敗するケースを作るのは難しくありません。

```julia
struct BitVector <: AbstractArray{Bool, 1}; end
```

ここでは、パラメーターを持たない型`BitVector`を作成しましたが、要素型は完全に指定されています。つまり、`T`は`Bool`です。

もう一つの間違いは、`supertype`を使って型階層を上にたどろうとすることです。

```julia
eltype_wrong(::Type{AbstractArray{T}}) where {T} = T
eltype_wrong(::Type{AbstractArray{T, N}}) where {T, N} = T
eltype_wrong(::Type{A}) where {A<:AbstractArray} = eltype_wrong(supertype(A))
```

宣言型では機能しますが、スーパータイプを持たない型では失敗します。

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

汎用コードを書くときは、型のレイアウトを一部変更し、それに伴って型パラメーターも変更した、類似のオブジェクトを構築する必要がよくあります。たとえば、要素型が任意の抽象配列を扱いながら、特定の要素型を使って計算を行いたい場合があります。この型変換の方法を定義するには、`AbstractArray{T}`の各サブタイプに対してメソッドを実装する必要があります。あるサブタイプを、型パラメーターの異なる別のサブタイプへ変換する汎用的な方法はありません。

`AbstractArray`のサブタイプでは、通常、この処理のために2つのメソッドを実装します。1つは入力配列を、特定の`AbstractArray{T, N}`抽象型のサブタイプに変換するメソッド、もう1つは特定の要素型を持つ未初期化配列を作成するメソッドです。これらの実装例はJulia Baseにあります。以下は、`input`と`output`が同じ型になることを保証する、基本的な使用例です。

```julia
input = convert(AbstractArray{Eltype}, input)
output = similar(input, Eltype)
```

これを拡張して、アルゴリズムで入力配列のコピーが必要な場合を考えます。[`convert`](@ref)では、戻り値が元の入力とエイリアスになる可能性があるため不十分です。[`similar`](@ref)（出力配列の作成）と[`copyto!`](@ref)（入力データの格納）を組み合わせると、入力引数の変更可能なコピーが必要であることを汎用的に表現できます。

```julia
copy_with_eltype(input, Eltype) = copyto!(similar(input, Eltype), input)
```

### Iterated dispatch

複数階層のパラメトリックな引数リストに対してディスパッチするには、各階層のディスパッチを別々の関数に分けるのが最適な場合がよくあります。これは単一ディスパッチに似た方法に思えるかもしれませんが、以下で見るように、より柔軟です。

たとえば、配列の要素型に基づいてディスパッチしようとすると、曖昧さが生じることがよくあります。その代わりに、一般的なコードではまずコンテナー型に基づいてディスパッチし、次に`eltype`に基づく、より具体的なメソッドへ再帰的に処理を進めます。ほとんどの場合、アルゴリズムはこの階層的な方法に自然に適合しますが、そうでない場合は、この厳密な構造を手作業で解決する必要があります。たとえば、2つの行列を加算する処理には、このようなディスパッチの分岐が見られます。

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

上記の段階的なディスパッチを自然に拡張すると、型階層で定義される集合とは独立した型の集合に基づいてディスパッチできるよう、メソッド選択にもう一つの階層を加えることができます。対象の型を列挙した`Union`を書けば、そのような集合を作れます。しかし、`Union`型は作成後に変更できないため、この集合を拡張できません。一方、["Holy-trait"](https://github.com/JuliaLang/julia/issues/2345#issuecomment-54537633)と呼ばれることの多い設計パターンを使えば、拡張可能な集合を実装できます。

このパターンでは、関数の引数が属する各トレイト集合に対して、異なるシングルトン値（または型）を返す汎用関数を定義します。この関数が純粋関数であれば、通常のディスパッチと比べて性能への影響はありません。

前の節の例では、[`map`](@ref)と[`promote`](@ref)の実装の詳細を省略しました。どちらも、こうしたトレイトを使って動作します。`map`の実装のように行列を走査する場合、重要な問題の一つは、データをどの順序でたどるかです。`AbstractArray`のサブタイプが[`Base.IndexStyle`](@ref)トレイトを実装していれば、`map`などの関数は、この情報に基づいて最適なアルゴリズムを選択できます（[Abstract Array Interface](@ref man-interface-array)を参照）。この仕組みにより、各サブタイプが`map`の独自実装を用意する必要はありません。汎用定義とトレイトクラスによって、システムが最速の実装を選択できるからです。以下は、トレイトに基づくディスパッチを示す、`map`の簡単な実装例です。

```julia
map(f, a::AbstractArray, b::AbstractArray) = map(Base.IndexStyle(a, b), f, a, b)
# generic implementation:
map(::Base.IndexCartesian, f, a::AbstractArray, b::AbstractArray) = ...
# linear-indexing implementation (faster)
map(::Base.IndexLinear, f, a::AbstractArray, b::AbstractArray) = ...
```

このトレイトベースの方法は、スカラー`+`が使う[`promote`](@ref)の仕組みにも使われています。ここでは[`promote_type`](@ref)を使い、オペランド2つの型に基づいて、演算に適した共通型を返します。これにより、考えられる型引数のペアごとにすべての関数を実装する代わりに、各型から共通型への変換処理と、型のペアごとに優先する昇格規則をまとめた表を用意するだけで済みます。

### Output-type computation

トレイトベースの昇格についての説明は、次の設計パターン、すなわち行列演算の出力要素型の計算へとつながります。

加算などの基本演算を実装する際は、[`promote_type`](@ref)関数を使って、必要な出力型を計算します。（前述のとおり、これは`+`の呼び出しにある`promote`の呼び出しで確認できます。）

行列に対するより複雑な関数では、さらに複雑な一連の演算に対する戻り値の型を計算する必要がある場合があります。多くの場合、次の手順で行います。

1. アルゴリズムのカーネルが実行する一連の演算を表す、小さな関数`op`を書く。
2. 結果の行列の要素型`R`を、`promote_op(op, argument_types...)`として計算する。ここで`argument_types`は、各入力配列に`eltype`を適用して求める。
3. 出力配列の必要な次元を`dims`として、出力行列を`similar(R, dims)`として構築する。

より具体的な例として、汎用的な正方行列の乗算を擬似コードで書くと、次のようになります。

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

コンパイル時間とテストの複雑さを大幅に減らす方法の一つは、必要な型への変換処理と計算処理を分離することです。こうすると、コンパイラーは大きなカーネル本体とは独立して、変換処理を特殊化し、インライン化できます。

これは、より広い型の集合から、アルゴリズムが実際にサポートする特定の引数型へ変換する際によく使われるパターンです。

```julia
complexfunction(arg::Int) = ...
complexfunction(arg::Any) = complexfunction(convert(Int, arg))

matmul(a::T, b::T) = ...
matmul(a, b) = matmul(promote(a, b)...)
```

## Parametrically-constrained Varargs methods

関数パラメーターを使うと、「可変長引数」関数（[Varargs Functions](@ref)）に渡せる引数の個数も制約できます。この制約を示すには、`Vararg{T,N}`という表記を使います。たとえば、次のように書きます。

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

さらに便利なことに、パラメーターを使って可変長引数メソッドを制約できます。たとえば、次のメソッドは、

```julia
function getindex(A::AbstractArray{T,N}, indices::Vararg{Number,N}) where {T,N}
```

`indices`の個数が配列の次元数と一致する場合にのみ呼び出されます。

渡された引数の型だけを制約する場合は、`Vararg{T}`を`T...`と同じ意味で書けます。たとえば、`f(x::Int...) = x`は`f(x::Vararg{Int}) = x`の省略形です。

## Note on Optional and keyword Arguments

[Functions](@ref man-functions)で簡単に触れたように、省略可能な引数は複数のメソッド定義を表す構文として実装されています。たとえば、次の定義は、

```julia
f(a=1,b=2) = a+2b
```

次の3つのメソッドに展開されます。

```julia
f(a,b) = a+2b
f(a) = f(a,2)
f() = f(1,2)
```

つまり、`f()`を呼び出すことは、`f(1,2)`を呼び出すことと同じです。この場合、結果は`5`になります。これは、`f(1,2)`が、上記の`f`の最初のメソッドを呼び出すためです。ただし、常にそうなるとは限りません。整数に対してより具体的な4つ目のメソッドを定義すると、

```julia
f(a::Int,b::Int) = a-2b
```

`f()`と`f(1,2)`のどちらを呼び出しても、結果は`-3`になります。つまり、省略可能な引数は関数に結び付いており、その関数の特定のメソッドに結び付いているわけではありません。どのメソッドが呼び出されるかは、省略可能な引数の型によって決まります。省略可能な引数をグローバル変数に基づいて定義した場合は、その型が実行時に変わることさえあります。

キーワード引数は、通常の位置引数とは大きく異なる振る舞いをします。特に、メソッドのディスパッチには関与しません。メソッドは位置引数だけに基づいて選択され、キーワード引数は一致するメソッドが特定された後に処理されます。

!!! warning "既知のバグ: キーワード引数の有無がディスパッチに影響する"
    長年存在するバグ（[#9498](https://github.com/JuliaLang/julia/issues/9498)）のため、キーワード引数を指定した呼び出しでは、キーワード引数を受け付けるメソッドだけが候補になります。その結果、キーワード引数を受け付けない、より具体的なメソッドではなく、具体性の低いメソッドが選ばれることがあります。

    ```julia
    julia> f(x; y=10) = "generic";

    julia> f(x::Int) = "int-specific";

    julia> f(1)
    "int-specific"

    julia> f(1; y=2)  # bug: bypasses the more specific method
    "generic"
    ```

    関連する問題として、キーワード引数のないメソッドを再定義しても、位置引数のシグネチャが同じ以前の定義におけるキーワード引数の処理は置き換わりません。表示されるメソッドは1つだけですが、この問題は残ります。

    ```julia
    julia> g(x; y=1) = "with keywords";

    julia> g(x) = "without keywords";

    julia> g
    g (generic function with 1 method)

    julia> g(1)
    "without keywords"

    julia> g(1; y=2)  # bug: calls the overwritten definition
    "with keywords"
    ```

    この警告は現状の説明であり、推奨事項ではありません。この動作に依存するコードを書かないでください。キーワード引数を使う呼び出しにも特殊化したメソッドを適用できるようにするには、キーワード引数を繰り返し指定するか、`kwargs...`で任意のキーワード引数をまとめて受け取るなどして、そのメソッド独自のキーワードインターフェースを用意してください。


## Function-like objects

メソッドは型に関連付けられているため、任意のJuliaオブジェクトの型にメソッドを追加すれば、そのオブジェクトを「呼び出し可能」にできます。

たとえば、多項式の係数を格納しながら、多項式を評価する関数のように振る舞う型を定義できます。

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

関数は名前ではなく型で指定されていることに注目してください。通常の関数と同様に、簡潔な構文も使えます。関数本体では、`p`が呼び出されたオブジェクトを参照します。`Polynomial`は、次のように使えます。

```jldoctest polynomial
julia> poly = Polynomial([1,10,100])
Polynomial{Int64}([1, 10, 100])

julia> poly(3)
931

julia> poly()
2551
```

この仕組みは、Juliaにおける型コンストラクターやクロージャ（周囲の環境を参照する内部関数）の動作を支える重要な要素でもあります。

## Empty generic functions

メソッドをまだ追加せずに、汎用関数だけを導入したい場合もあります。これは、インターフェースの定義と実装を分離するために使えます。また、ドキュメントやコードの可読性を高める目的で行うこともあります。構文としては、引数のタプルを伴わない空の`function`ブロックを使います。

```julia
function emptyfunc end
```

## [Method design and the avoidance of ambiguities](@id man-method-design-ambiguities)

Juliaのメソッド多相性は、最も強力な機能の一つです。しかし、その力を活用するには設計上の課題が生じることがあります。特に、複雑なメソッド階層では、[ambiguities](@ref man-ambiguities)が発生するのは珍しくありません。

先ほど、次のような曖昧さは、

```julia
f(x, y::Int) = 1
f(x::Int, y) = 2
```

次のメソッドを定義すれば解消できると説明しました。

```julia
f(x::Int, y::Int) = 3
```

これは多くの場合、適切な方法です。しかし、この助言を考えずに適用すると、逆効果になることもあります。特に、汎用関数のメソッドが増えるほど、曖昧さが生じる可能性も高まります。メソッド階層がこの単純な例より複雑になったら、別の解決策も慎重に検討するとよいでしょう。

以下では、具体的な課題と、それを解決するための別の方法をいくつか説明します。

### Tuple and NTuple arguments

`Tuple`（および`NTuple`）の引数には、特有の課題があります。たとえば、

```julia
f(x::NTuple{N,Int}) where {N} = 1
f(x::NTuple{N,Float64}) where {N} = 2
```

これらは、`N == 0`の可能性があるため、曖昧になります。要素がないので、`Int`と`Float64`のどちらの形式を呼び出すべきか判断できません。曖昧さを解消する方法の一つは、空のタプルに対するメソッドを定義することです。

```julia
f(x::Tuple{}) = 3
```

別の方法として、1つを除くすべてのメソッドで、タプルに要素が少なくとも1つあることを要求できます。

```julia
f(x::NTuple{N,Int}) where {N} = 1           # this is the fallback
f(x::Tuple{Float64, Vararg{Float64}}) = 2   # this requires at least one Float64
```

### [Orthogonalize your design](@id man-methods-orthogonalize)

2つ以上の引数に基づくディスパッチを検討するときは、「ラッパー」関数を使うと設計が簡潔になるかどうか考えてみてください。たとえば、複数の形式を書く代わりに、

```julia
f(x::A, y::A) = ...
f(x::A, y::B) = ...
f(x::B, y::A) = ...
f(x::B, y::B) = ...
```

次のように定義する方法があります。

```julia
f(x::A, y::A) = ...
f(x, y) = f(g(x), g(y))
```

ここで`g`は、引数を`A`型に変換します。これは、[orthogonal design](https://en.wikipedia.org/wiki/Orthogonality_(programming))という、より一般的な原則の具体例です。この原則では、別々の概念を別々のメソッドに割り当てます。この場合、`g`には、おそらくフォールバック定義が必要です。

```julia
g(x::A) = x
```

関連する方法として、`promote`を使い、`x`と`y`を共通の型に揃える方法があります。

```julia
f(x::T, y::T) where {T} = ...
f(x, y) = f(promote(x, y)...)
```

この設計には、`x`と`y`を同じ型に変換する適切な昇格メソッドがない場合、2つ目のメソッドが自分自身を無限に再帰的に呼び出し、スタックオーバーフローを引き起こす可能性があります。

### Dispatch on one argument at a time

複数の引数に基づくディスパッチが必要で、フォールバックの組み合わせが多すぎてすべての形式を定義するのが現実的でない場合は、「名前のカスケード」を導入する方法を検討してください。たとえば、最初の引数に基づいてディスパッチし、その後、内部メソッドを呼び出します。

```julia
f(x::A, y) = _fA(x, y)
f(x::B, y) = _fB(x, y)
```

こうすると、内部メソッド`_fA`と`_fB`は、`x`に関して互いに曖昧になる心配なく、`y`に基づいてディスパッチできます。

ただし、この方法には少なくとも1つ大きな欠点があります。多くの場合、ユーザーはエクスポートされた関数`f`に特殊化を追加して、`f`の振る舞いをさらにカスタマイズできません。その代わりに、内部メソッド`_fA`と`_fB`に特殊化を定義する必要があり、エクスポートされたメソッドと内部メソッドの境界が曖昧になります。

### Abstract containers and element types

可能であれば、抽象コンテナーの特定の要素型に基づいてディスパッチするメソッドは定義しないようにしてください。たとえば、

```julia
-(A::AbstractArray{T}, b::Date) where {T<:Date}
```

次のメソッドを定義する人に、曖昧さを生じさせます。

```julia
-(A::MyArrayType{T}, b::T) where {T}
```

最善の方法は、これらのメソッドの*どちらも*定義しないことです。その代わりに、汎用メソッド`-(A::AbstractArray, b)`に頼り、`similar`や`-`のような汎用呼び出しを使って、コンテナー型と要素型それぞれに適切な処理を行うようにします。これは、メソッドを[orthogonalize](@ref man-methods-orthogonalize)するという助言を、より複雑な形で適用したものです。

この方法が使えない場合は、ほかの開発者と曖昧さの解消について話し合うとよいでしょう。先に定義されたメソッドだからといって、変更や削除ができないとは限りません。最後の手段として、開発者の一人が次の「応急処置」メソッドを定義し、

```julia
-(A::MyArrayType{T}, b::Date) where {T<:Date} = ...
```

力ずくで曖昧さを解消することもできます。

### Complex method "cascades" with default arguments

デフォルト値を与えるメソッドの「カスケード」を定義する場合、デフォルト値に対応する引数を省略しないよう注意してください。たとえば、信号の端をパディングして処理するデジタルフィルタリングアルゴリズムを書くとします。

```julia
function myfilter(A, kernel, ::Replicate)
    Apadded = replicate_edges(A, size(kernel))
    myfilter(Apadded, kernel)  # now perform the "real" computation
end
```

このメソッドは、デフォルトのパディングを指定する次のメソッドと衝突します。

```julia
myfilter(A, kernel) = myfilter(A, kernel, Replicate()) # replicate the edge by default
```

この2つのメソッドを組み合わせると、`A`が際限なく大きくなりながら、無限再帰が発生します。

より適切な設計では、呼び出し階層を次のように定義します。

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

`NoPad`は、ほかの種類のパディングと同じ引数位置に指定されるため、ディスパッチ階層を整理しやすく、曖昧さも生じにくくなります。また、「公開」インターフェースである`myfilter`も拡張されます。パディングを明示的に指定したいユーザーは、`NoPad`の形式を直接呼び出せます。

## Defining methods in local scope

[local scope](@ref scope-of-variables)内でメソッドを定義できます。たとえば、次のように書けます。

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

ただし、次のように、条件付きや制御フローの中でローカルメソッドを定義しては*いけません*。

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

どの関数が最終的に定義されるのか明確でないためです。将来的には、このようなローカルメソッドの定義がエラーになる可能性があります。

このような場合は、代わりに無名関数を使ってください。

```julia
function f2(inc)
    g = if inc
        x -> x + 1
    else
        x -> x - 1
    end
end
```

[^Clarke61]: Arthur C. Clarke, *Profiles of the Future* (1961): クラークの第三法則。

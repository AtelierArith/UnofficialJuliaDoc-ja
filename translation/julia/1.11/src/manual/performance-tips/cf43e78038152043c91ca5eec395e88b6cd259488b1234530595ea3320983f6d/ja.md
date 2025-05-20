# [Performance Tips](@id man-performance-tips)

以下のセクションでは、Juliaコードをできるだけ速く実行するためのいくつかのテクニックを簡単に紹介します。

## Performance critical code should be inside a function

パフォーマンスが重要なコードは、関数内に置くべきです。関数内のコードは、Juliaのコンパイラの動作により、トップレベルのコードよりもはるかに速く実行される傾向があります。

関数の使用はパフォーマンスだけでなく重要です。関数は再利用可能でテスト可能であり、どのステップが実行されているのか、入力と出力が何であるかを明確にします。[Write functions, not just scripts](@ref)は、Juliaのスタイルガイドの推奨事項でもあります。

関数はグローバル変数に直接作用するのではなく、引数を取るべきです。次のポイントを参照してください。

## Avoid untyped global variables

未型付けのグローバル変数の値は、いつでも変更される可能性があり、その結果、型が変わることがあります。これにより、コンパイラがグローバル変数を使用するコードを最適化することが難しくなります。これは、型付き変数、つまりグローバルレベルの型エイリアスにも当てはまります。変数は可能な限りローカルであるか、関数に引数として渡されるべきです。

グローバル名は頻繁に定数であることがわかり、それをそのように宣言することでパフォーマンスが大幅に向上します：

```julia
const DEFAULT_VAL = 0
```

グローバルが常に同じ型であることが知られている場合、[the type should be annotated](@ref man-typed-globals)。

未型のグローバルの使用は、使用箇所でその型を注釈することによって最適化できます:

```julia
global x = rand(1000)

function loop_over_global()
    s = 0.0
    for i in x::Vector{Float64}
        s += i
    end
    return s
end
```

関数に引数を渡すことは、より良いスタイルです。これにより、より再利用可能なコードが得られ、入力と出力が明確になります。

!!! note
    REPL内のすべてのコードはグローバルスコープで評価されるため、トップレベルで定義されて割り当てられた変数は**グローバル**変数になります。モジュール内のトップレベルスコープで定義された変数もグローバルです。


次のREPLセッションでは：

```julia-repl
julia> x = 1.0
```

は次のように等しいです：

```julia-repl
julia> global x = 1.0
```

したがって、以前に議論されたすべてのパフォーマンスの問題が適用されます。

## Measure performance with [`@time`](@ref) and pay attention to memory allocation

パフォーマンスを測定するための便利なツールは、[`@time`](@ref) マクロです。ここでは、上記のグローバル変数を使った例を繰り返しますが、今回は型アノテーションを削除しています：

```jldoctest; setup = :(using Random; Random.seed!(1234)), filter = r"[0-9\.]+ seconds \(.*?\)"
julia> x = rand(1000);

julia> function sum_global()
           s = 0.0
           for i in x
               s += i
           end
           return s
       end;

julia> @time sum_global()
  0.011539 seconds (9.08 k allocations: 373.386 KiB, 98.69% compilation time)
523.0007221951678

julia> @time sum_global()
  0.000091 seconds (3.49 k allocations: 70.156 KiB)
523.0007221951678
```

最初の呼び出し（`@time sum_global()`）では、関数がコンパイルされます。（このセッションでまだ [`@time`](@ref) を使用していない場合、タイミングに必要な関数もコンパイルされます。）この実行の結果を真剣に受け取るべきではありません。2回目の実行では、時間を報告するだけでなく、かなりの量のメモリが割り当てられたことも示しています。ここでは、64ビット浮動小数点数のベクトル内のすべての要素の合計を計算しているだけなので、（ヒープ）メモリを割り当てる必要はないはずです。

`@time` が報告するのは特に *ヒープ* アロケーションであり、これは通常、可変オブジェクトや可変サイズのコンテナ（例えば `Array` や `Dict`、文字列、または実行時にのみ型が知られる「型不安定」オブジェクト）を作成または成長させるために必要です。このようなメモリブロックを割り当てる（または解放する）には、libc への高価な関数呼び出し（例えば C の `malloc` を介して）が必要になる場合があり、ガーベジコレクションのために追跡されなければなりません。それに対して、数値（ビッグナムを除く）、タプル、そして不変の `struct` のような不変値は、スタックや CPU レジスタメモリに格納できるため、通常は「割り当てる」ことのパフォーマンスコストを心配する必要はありません。

予期しないメモリ割り当ては、ほぼ常にコードに何らかの問題がある兆候であり、通常は型の安定性の問題や多くの小さな一時配列を作成することに関連しています。そのため、割り当て自体に加えて、あなたの関数のために生成されたコードが最適から遠い可能性が非常に高いです。このような兆候を真剣に受け止め、以下のアドバイスに従ってください。

この特定のケースでは、メモリ割り当ては型が不安定なグローバル変数 `x` の使用によるものであるため、代わりに `x` を関数の引数として渡すと、もはやメモリを割り当てず（以下に報告されている残りの割り当てはグローバルスコープで `@time` マクロを実行したことによるものです）、最初の呼び出しの後は大幅に速くなります：

```jldoctest sumarg; setup = :(using Random; Random.seed!(1234)), filter = r"[0-9\.]+ seconds \(.*?\)"
julia> x = rand(1000);

julia> function sum_arg(x)
           s = 0.0
           for i in x
               s += i
           end
           return s
       end;

julia> @time sum_arg(x)
  0.007551 seconds (3.98 k allocations: 200.548 KiB, 99.77% compilation time)
523.0007221951678

julia> @time sum_arg(x)
  0.000006 seconds (1 allocation: 16 bytes)
523.0007221951678
```

`@time` マクロ自体をグローバルスコープで実行した場合に見られる 1 回のアロケーションです。代わりに関数内でタイミングを実行すると、実際にアロケーションが行われていないことがわかります：

```jldoctest sumarg; filter = r"[0-9\.]+ seconds"
julia> time_sum(x) = @time sum_arg(x);

julia> time_sum(x)
  0.000002 seconds
523.0007221951678
```

いくつかの状況では、関数がその操作の一部としてメモリを割り当てる必要があり、これが上記の単純な図を複雑にする可能性があります。そのような場合は、問題を診断するために以下の [tools](@ref tools) のいずれかを使用するか、割り当てをアルゴリズム的な側面から分離する関数のバージョンを書くことを検討してください（[Pre-allocating outputs](@ref) を参照）。

!!! note
    より真剣なベンチマークを行う場合は、[BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) パッケージを検討してください。このパッケージは、ノイズを減らすために関数を複数回評価するなど、他にもさまざまな機能を提供します。


## [Tools](@id tools)

Juliaとそのパッケージエコシステムには、問題を診断し、コードのパフォーマンスを向上させるのに役立つツールが含まれています：

  * [Profiling](@ref) は、実行中のコードのパフォーマンスを測定し、ボトルネックとなる行を特定することができます。複雑なプロジェクトの場合、[ProfileView](https://github.com/timholy/ProfileView.jl) パッケージを使用すると、プロファイリング結果を視覚化するのに役立ちます。
  * [JET](https://github.com/aviatesk/JET.jl) パッケージは、コード内の一般的なパフォーマンス問題を見つけるのに役立ちます。
  * 予期しない大きなメモリ割り当ては、[`@time`](@ref)、[`@allocated`](@ref)、またはプロファイラ（ガーベジコレクションルーチンへの呼び出しを通じて）によって報告され、コードに問題がある可能性を示唆しています。割り当ての別の理由が見当たらない場合は、型の問題を疑ってください。また、`--track-allocation=user`オプションを使用してJuliaを起動し、結果の`*.mem`ファイルを調べることで、これらの割り当てが発生する場所に関する情報を確認できます。[Memory allocation analysis](@ref)を参照してください。
  * `@code_warntype`は、型の不確実性をもたらす式を見つけるのに役立つコードの表現を生成します。以下の[`@code_warntype`](@ref)を参照してください。

## [Avoid containers with abstract type parameters](@id man-performance-abstract-container)

パラメータ化された型、配列を含む場合、可能な限り抽象型でパラメータ化することは避けるのが最良です。

以下を考慮してください：

```jldoctest
julia> a = Real[]
Real[]

julia> push!(a, 1); push!(a, 2.0); push!(a, π)
3-element Vector{Real}:
 1
 2.0
 π = 3.1415926535897...
```

`a`は抽象型[`Real`](@ref)の配列であるため、任意の`Real`値を保持できる必要があります。`Real`オブジェクトは任意のサイズと構造を持つことができるため、`a`は個別に割り当てられた`Real`オブジェクトへのポインタの配列として表現されなければなりません。しかし、もし`a`に同じ型の数値、例えば[`Float64`](@ref)のみを格納することを許可する場合、これらはより効率的に格納できます。

```jldoctest
julia> a = Float64[]
Float64[]

julia> push!(a, 1); push!(a, 2.0); push!(a,  π)
3-element Vector{Float64}:
 1.0
 2.0
 3.141592653589793
```

`a` に数値を割り当てると、これらは `Float64` に変換され、`a` は効率的に操作できる64ビット浮動小数点値の連続したブロックとして保存されます。

コンテナに抽象値型を使用せざるを得ない場合、ランタイム型チェックを避けるために `Any` でパラメータ化する方が良いことがあります。例えば、`IdDict{Any, Any}` は `IdDict{Type, Vector}` よりもパフォーマンスが向上します。

[Parametric Types](@ref)に関する議論も参照してください。

## Type declarations

多くのオプションの型宣言を持つ言語では、宣言を追加することがコードを速く実行する主な方法です。しかし、これはJuliaでは*ありません*。Juliaでは、コンパイラは一般的にすべての関数引数、ローカル変数、および式の型を知っています。ただし、宣言が役立つ特定のいくつかのケースがあります。

### Avoid fields with abstract type

フィールドの型を指定せずに型を宣言することができます：

```jldoctest myambig
julia> struct MyAmbiguousType
           a
       end
```

これにより、`a` は任意の型であることができます。これはしばしば便利ですが、欠点もあります。`MyAmbiguousType` 型のオブジェクトの場合、コンパイラは高性能なコードを生成できません。その理由は、コンパイラがオブジェクトの値ではなく型を使用してコードの構築方法を決定するからです。残念ながら、`MyAmbiguousType` 型のオブジェクトについては、非常に少ない情報しか推測できません。

```jldoctest myambig
julia> b = MyAmbiguousType("Hello")
MyAmbiguousType("Hello")

julia> c = MyAmbiguousType(17)
MyAmbiguousType(17)

julia> typeof(b)
MyAmbiguousType

julia> typeof(c)
MyAmbiguousType
```

`b` と `c` の値は同じ型ですが、メモリ内のデータの基礎となる表現は非常に異なります。フィールド `a` に数値のみを格納しても、[`UInt8`](@ref) のメモリ表現が [`Float64`](@ref) と異なるという事実は、CPU がそれらを異なる種類の命令を使用して処理する必要があることを意味します。必要な情報が型に含まれていないため、そのような決定は実行時に行わなければなりません。これによりパフォーマンスが低下します。

`a`の型を宣言することで、より良い結果を得ることができます。ここでは、`a`がいくつかの型のいずれかである可能性がある場合に焦点を当てており、その場合の自然な解決策はパラメータを使用することです。例えば：

```jldoctest myambig2
julia> mutable struct MyType{T<:AbstractFloat}
           a::T
       end
```

これはより良い選択です。

```jldoctest myambig2
julia> mutable struct MyStillAmbiguousType
           a::AbstractFloat
       end
```

最初のバージョンは、ラッパーオブジェクトの型から `a` の型を指定するためです。例えば：

```jldoctest myambig2
julia> m = MyType(3.2)
MyType{Float64}(3.2)

julia> t = MyStillAmbiguousType(3.2)
MyStillAmbiguousType(3.2)

julia> typeof(m)
MyType{Float64}

julia> typeof(t)
MyStillAmbiguousType
```

フィールド `a` の型は `m` の型から容易に決定できますが、`t` の型からは決定できません。実際、`t` ではフィールド `a` の型を変更することが可能です：

```jldoctest myambig2
julia> typeof(t.a)
Float64

julia> t.a = 4.5f0
4.5f0

julia> typeof(t.a)
Float32
```

対照的に、一度 `m` が構築されると、`m.a` の型は変更できません:

```jldoctest myambig2
julia> m.a = 4.5f0
4.5f0

julia> typeof(m.a)
Float64
```

`m`の型から`m.a`の型が知られているという事実と、その型が関数の途中で変わることができないという事実は、コンパイラが`m`のようなオブジェクトに対して高度に最適化されたコードを生成できることを可能にしますが、`t`のようなオブジェクトに対してはそうではありません。

もちろん、これはすべて `m` を具体的な型で構築した場合にのみ当てはまります。抽象型で明示的に構築することでこれを破ることができます：

```jldoctest myambig2
julia> m = MyType{AbstractFloat}(3.2)
MyType{AbstractFloat}(3.2)

julia> typeof(m.a)
Float64

julia> m.a = 4.5f0
4.5f0

julia> typeof(m.a)
Float32
```

実用的な目的のために、そのようなオブジェクトは `MyStillAmbiguousType` のオブジェクトと同様に振る舞います。

単純な関数に対して生成されるコードの量を比較することは非常に教育的です。

```julia
func(m::MyType) = m.a+1
```

使用して

```julia
code_llvm(func, Tuple{MyType{Float64}})
code_llvm(func, Tuple{MyType{AbstractFloat}})
```

長さの理由から、結果はここに表示されていませんが、あなた自身で試してみることをお勧めします。最初のケースでは型が完全に指定されているため、コンパイラは実行時に型を解決するためのコードを生成する必要がありません。これにより、コードが短く、より高速になります。

完全にパラメータ化されていない型は抽象型のように振る舞うことも考慮すべきです。たとえば、完全に指定された `Array{T,n}` は具体的ですが、パラメータが与えられていない `Array` 自体は具体的ではありません:

```jldoctest myambig3
julia> !isconcretetype(Array), !isabstracttype(Array), isstructtype(Array), !isconcretetype(Array{Int}), isconcretetype(Array{Int,1})
(true, true, true, true, true)
```

この場合、`MyType`をフィールド`a::Array`で宣言するのではなく、フィールドを`a::Array{T,N}`または`a::A`として宣言する方が良いでしょう。ここで、`{T,N}`または`A`は`MyType`のパラメータです。

前のアドバイスは、構造体のフィールドが関数、またはより一般的には呼び出し可能なオブジェクトである場合に特に有用です。構造体を次のように定義するのは非常に魅力的です：

```julia
struct MyCallableWrapper
    f::Function
end
```

しかし、`Function`は抽象型であるため、`wrapper.f`へのすべての呼び出しは、フィールド`f`へのアクセスの型不安定性のために動的ディスパッチを必要とします。代わりに、次のように書くべきです：

```julia
struct MyCallableWrapper{F}
    f::F
end
```

ほぼ同じ動作を持ちながら、はるかに高速になります（型の不安定性が排除されるため）。`F<:Function`を課さないことに注意してください。これは、`Function`のサブタイプでない呼び出し可能なオブジェクトもフィールド`f`に対して許可されることを意味します。

### Avoid fields with abstract containers

コンテナタイプにも同じベストプラクティスが適用されます：

```jldoctest containers
julia> struct MySimpleContainer{A<:AbstractVector}
           a::A
       end

julia> struct MyAmbiguousContainer{T}
           a::AbstractVector{T}
       end

julia> struct MyAlsoAmbiguousContainer
           a::Array
       end
```

例えば：

```jldoctest containers
julia> c = MySimpleContainer(1:3);

julia> typeof(c)
MySimpleContainer{UnitRange{Int64}}

julia> c = MySimpleContainer([1:3;]);

julia> typeof(c)
MySimpleContainer{Vector{Int64}}

julia> b = MyAmbiguousContainer(1:3);

julia> typeof(b)
MyAmbiguousContainer{Int64}

julia> b = MyAmbiguousContainer([1:3;]);

julia> typeof(b)
MyAmbiguousContainer{Int64}

julia> d = MyAlsoAmbiguousContainer(1:3);

julia> typeof(d), typeof(d.a)
(MyAlsoAmbiguousContainer, Vector{Int64})

julia> d = MyAlsoAmbiguousContainer(1:1.0:3);

julia> typeof(d), typeof(d.a)
(MyAlsoAmbiguousContainer, Vector{Float64})

```

`MySimpleContainer` の場合、オブジェクトはその型とパラメータによって完全に指定されているため、コンパイラは最適化された関数を生成できます。ほとんどの場合、これで十分でしょう。

コンパイラは現在、その仕事を完璧にこなすことができますが、*あなた*が `a` の *要素タイプ* に応じてコードが異なる動作をすることを望む場合があります。通常、これを達成する最良の方法は、特定の操作（ここでは `foo`）を別の関数にラップすることです：

```jldoctest containers
julia> function sumfoo(c::MySimpleContainer)
           s = 0
           for x in c.a
               s += foo(x)
           end
           s
       end
sumfoo (generic function with 1 method)

julia> foo(x::Integer) = x
foo (generic function with 1 method)

julia> foo(x::AbstractFloat) = round(x)
foo (generic function with 2 methods)
```

これにより、すべてのケースでコンパイラが最適化されたコードを生成できるようにしつつ、物事をシンプルに保つことができます。

ただし、`MySimpleContainer`のフィールド`a`の異なる要素タイプや`AbstractVector`の異なるバージョンの外部関数を宣言する必要がある場合があります。次のようにすることができます：

```jldoctest containers
julia> function myfunc(c::MySimpleContainer{<:AbstractArray{<:Integer}})
           return c.a[1]+1
       end
myfunc (generic function with 1 method)

julia> function myfunc(c::MySimpleContainer{<:AbstractArray{<:AbstractFloat}})
           return c.a[1]+2
       end
myfunc (generic function with 2 methods)

julia> function myfunc(c::MySimpleContainer{Vector{T}}) where T <: Integer
           return c.a[1]+3
       end
myfunc (generic function with 3 methods)
```

```jldoctest containers
julia> myfunc(MySimpleContainer(1:3))
2

julia> myfunc(MySimpleContainer(1.0:3))
3.0

julia> myfunc(MySimpleContainer([1:3;]))
4
```

### Annotate values taken from untyped locations

データ構造は、任意の型の値を含む可能性があるため（`Array{Any}`型の配列）、扱うのが便利なことがよくあります。しかし、これらの構造を使用していて、要素の型がわかっている場合は、その知識をコンパイラと共有することが役立ちます。

```julia
function foo(a::Array{Any,1})
    x = a[1]::Int32
    b = x+1
    ...
end
```

ここでは、`a`の最初の要素が[`Int32`](@ref)であることがわかりました。このように注釈を付けることで、値が期待される型でない場合にランタイムエラーが発生し、特定のバグを早期に検出できるという追加の利点があります。

`a[1]`の型が正確に知られていない場合、`x`は`x = convert(Int32, a[1])::Int32`を使って宣言できます。[`convert`](@ref)関数を使用することで、`a[1]`は`Int32`に変換可能な任意のオブジェクト（例えば`UInt8`）であることができ、型要件を緩めることでコードの汎用性が向上します。この文脈では、`convert`自体が型安定性を達成するために型注釈を必要とすることに注意してください。これは、コンパイラが関数のすべての引数の型が知られていない限り、関数の戻り値の型を推測できないためです。

型注釈は、型が抽象的であるか、実行時に構築される場合、パフォーマンスを向上させることはなく（実際には妨げることさえあります）、これはコンパイラが注釈を使用してその後のコードを特化できず、型チェック自体に時間がかかるためです。例えば、次のコードでは：

```julia
function nr(a, prec)
    ctype = prec == 32 ? Float32 : Float64
    b = Complex{ctype}(a)
    c = (b + 1.0f0)::Complex{ctype}
    abs(c)
end
```

`c`のアノテーションはパフォーマンスに悪影響を及ぼします。実行時に構築された型を含むパフォーマンスの良いコードを書くには、以下で説明する[function-barrier technique](@ref kernel-functions)を使用し、構築された型がカーネル関数の引数型の中に現れるようにして、カーネル操作がコンパイラによって適切に特化されるようにします。たとえば、上記のスニペットでは、`b`が構築されるとすぐに、別の関数`k`、すなわちカーネルに渡すことができます。たとえば、関数`k`が`b`を型パラメータ`T`の型`Complex{T}`の引数として宣言する場合、`k`内の代入文に現れる型アノテーションは次のようになります：

```julia
c = (b + 1.0f0)::Complex{T}
```

パフォーマンスを妨げることはありません（しかし、助けることもありません）なぜなら、コンパイラは`k`がコンパイルされる時点で`c`の型を決定できるからです。

### Be aware of when Julia avoids specializing

ヒューリスティックとして、Juliaは特定の3つのケース、すなわち`Type`、`Function`、および`Vararg`において、引数の型パラメータに対して自動的に[specializing](@ref man-method-specializations)を避けます。Juliaは引数がメソッド内で使用される場合には常に特化しますが、引数が別の関数に単に渡される場合には特化しません。これは通常、ランタイムでのパフォーマンスに影響を与えず、[improves compiler performance](@ref compiler-efficiency-issues)。もしあなたのケースでランタイムにおいてパフォーマンスに影響がある場合は、メソッド宣言に型パラメータを追加することで特化をトリガーできます。以下はいくつかの例です：

これは専門的ではありません:

```julia
function f_type(t)  # or t::Type
    x = ones(t, 10)
    return sum(map(sin, x))
end
```

しかし、これは次のことになります：

```julia
function g_type(t::Type{T}) where T
    x = ones(T, 10)
    return sum(map(sin, x))
end
```

これらは専門化しません:

```julia
f_func(f, num) = ntuple(f, div(num, 2))
g_func(g::Function, num) = ntuple(g, div(num, 2))
```

しかし、これは次のようになります：

```julia
h_func(h::H, num) where {H} = ntuple(h, div(num, 2))
```

これは専門的ではありません:

```julia
f_vararg(x::Int...) = tuple(x...)
```

しかし、これは次のことを行います：

```julia
g_vararg(x::Vararg{Int, N}) where {N} = tuple(x...)
```

1つの型パラメータを導入するだけで、他の型が制約されていなくても特化を強制できます。たとえば、これは特化され、引数がすべて同じ型でない場合に便利です：

```julia
h_vararg(x::Vararg{Any, N}) where {N} = tuple(x...)
```

[`@code_typed`](@ref) とその仲間は、ジュリアが通常そのメソッド呼び出しを特化しない場合でも、常に特化されたコードを表示します。引数の型が変更されたときに特化が生成されるかどうかを確認したい場合は、[method internals](@ref ast-lowered-method) をチェックする必要があります。つまり、`Base.specializations(@which f(...))` に問題の引数に対する特化が含まれているかどうかを確認します。

## Break functions into multiple definitions

関数を多くの小さな定義として書くことで、コンパイラは最も適切なコードを直接呼び出すことができ、さらにはインライン化することも可能です。

ここに「複合関数」の例がありますが、実際には複数の定義として書かれるべきです：

```julia
using LinearAlgebra

function mynorm(A)
    if isa(A, Vector)
        return sqrt(real(dot(A,A)))
    elseif isa(A, Matrix)
        return maximum(svdvals(A))
    else
        error("mynorm: invalid argument")
    end
end
```

これをより簡潔かつ効率的に書くことができます:

```julia
mynorm(x::Vector) = sqrt(real(dot(x, x)))
mynorm(A::Matrix) = maximum(svdvals(A))
```

ただし、コンパイラは `mynorm` の例として書かれたコードの無駄な分岐を最適化するのが非常に効率的であることに注意する必要があります。

## Write "type-stable" functions

可能な場合は、関数が常に同じ型の値を返すことを保証するのが役立ちます。次の定義を考えてみてください：

```julia
pos(x) = x < 0 ? 0 : x
```

このように見えるかもしれませんが、問題は `0` が整数（型 `Int`）であり、`x` は任意の型である可能性があることです。したがって、`x` の値に応じて、この関数は2つの型のいずれかの値を返す可能性があります。この動作は許可されており、場合によっては望ましいこともあります。しかし、次のように簡単に修正できます：

```julia
pos(x) = x < 0 ? zero(x) : x
```

[`oneunit`](@ref) 関数と、より一般的な [`oftype(x, y)`](@ref) 関数があります。これらは、`y` を `x` の型に変換して返します。

## Avoid changing the type of a variable

関数内で繰り返し使用される変数に対しても、類似の「型安定性」問題が存在します：

```julia
function foo()
    x = 1
    for i = 1:10
        x /= rand()
    end
    return x
end
```

ローカル変数 `x` は整数として始まり、1回のループの反復後に浮動小数点数になります（[`/`](@ref) 演算子の結果）。これにより、コンパイラがループの本体を最適化するのが難しくなります。いくつかの修正方法があります：

  * `x`を`x = 1.0`で初期化します。
  * `x::Float64 = 1` として `x` の型を明示的に宣言します。
  * `x = oneunit(Float64)`の明示的な変換を使用します。
  * 最初のループの反復を `x = 1 / rand()` で初期化し、その後 `for i = 2:10` でループします。

## [Separate kernel functions (aka, function barriers)](@id kernel-functions)

多くの関数は、いくつかのセットアップ作業を行い、その後、コア計算を実行するために多くの反復を行うというパターンに従います。可能であれば、これらのコア計算を別の関数に分けるのが良いアイデアです。たとえば、以下の作り話の関数は、ランダムに選ばれたタイプの配列を返します：

```jldoctest; setup = :(using Random; Random.seed!(1234))
julia> function strange_twos(n)
           a = Vector{rand(Bool) ? Int64 : Float64}(undef, n)
           for i = 1:n
               a[i] = 2
           end
           return a
       end;

julia> strange_twos(3)
3-element Vector{Int64}:
 2
 2
 2
```

これは次のように書かれるべきです：

```jldoctest; setup = :(using Random; Random.seed!(1234))
julia> function fill_twos!(a)
           for i = eachindex(a)
               a[i] = 2
           end
       end;

julia> function strange_twos(n)
           a = Vector{rand(Bool) ? Int64 : Float64}(undef, n)
           fill_twos!(a)
           return a
       end;

julia> strange_twos(3)
3-element Vector{Int64}:
 2
 2
 2
```

Juliaのコンパイラは、関数の境界で引数の型に特化したコードを生成します。そのため、元の実装ではループ中に`a`の型がわかりません（ランダムに選ばれるため）。したがって、2番目のバージョンは一般的に速く、内部ループは`fill_twos!`の一部として異なる型の`a`に対して再コンパイルできます。

第二の形式は、しばしばより良いスタイルであり、コードの再利用を促進することができます。

このパターンは、Julia Baseのいくつかの場所で使用されています。例えば、`vcat`や`hcat`を参照してください。[`abstractarray.jl`](https://github.com/JuliaLang/julia/blob/40fe264f4ffaa29b749bcf42239a89abdcbba846/base/abstractarray.jl#L1205-L1206)や、[`fill!`](@ref)関数を参照してください。この関数を使用する代わりに、自分の`fill_twos!`を書くこともできました。

`strange_twos`のような関数は、整数、浮動小数点数、文字列、またはその他の何かを含む可能性のある入力ファイルから読み込まれたデータなど、不確定な型のデータを扱うときに発生します。

## [Types with values-as-parameters](@id man-performance-value-type)

`N`次元配列を作成したいとしましょう。各軸のサイズが3の配列です。このような配列は次のように作成できます：

```jldoctest
julia> A = fill(5.0, (3, 3))
3×3 Matrix{Float64}:
 5.0  5.0  5.0
 5.0  5.0  5.0
 5.0  5.0  5.0
```

このアプローチは非常に効果的です：コンパイラは、`A` が `Array{Float64,2}` であることを理解できます。なぜなら、フィル値の型（`5.0::Float64`）と次元（`(3, 3)::NTuple{2,Int}`）を知っているからです。これは、コンパイラが同じ関数内での `A` の将来の使用に対して非常に効率的なコードを生成できることを意味します。

しかし、今、任意の次元で3×3×...の配列を作成する関数を書きたいとしましょう。関数を書くことに誘惑されるかもしれません。

```jldoctest
julia> function array3(fillval, N)
           fill(fillval, ntuple(d->3, N))
       end
array3 (generic function with 1 method)

julia> array3(5.0, 2)
3×3 Matrix{Float64}:
 5.0  5.0  5.0
 5.0  5.0  5.0
 5.0  5.0  5.0
```

これは機能しますが（`@code_warntype array3(5.0, 2)`を使用して自分で確認できます）、問題は出力タイプを推論できないことです。引数`N`は`Int`型の*値*であり、型推論はその値を事前に予測することができません。これは、この関数の出力を使用するコードが保守的でなければならず、`A`への各アクセス時に型をチェックする必要があることを意味します。そのようなコードは非常に遅くなります。

今、このような問題を解決する非常に良い方法は、[function-barrier technique](@ref kernel-functions)を使用することです。しかし、場合によっては、型の不安定性を完全に排除したいことがあります。そのような場合の一つのアプローチは、次元をパラメータとして渡すことです。例えば、`Val{T}()`を通じて（["Value types"](@ref)を参照）。

```jldoctest
julia> function array3(fillval, ::Val{N}) where N
           fill(fillval, ntuple(d->3, Val(N)))
       end
array3 (generic function with 1 method)

julia> array3(5.0, Val(2))
3×3 Matrix{Float64}:
 5.0  5.0  5.0
 5.0  5.0  5.0
 5.0  5.0  5.0
```

Juliaは、第二引数として`Val{::Int}`インスタンスを受け取る特別なバージョンの`ntuple`を持っています。`N`を型パラメータとして渡すことで、その「値」をコンパイラに知らしめます。したがって、このバージョンの`array3`は、コンパイラが戻り値の型を予測できるようにします。

しかし、そのような技術を利用することは驚くほど微妙です。たとえば、次のような関数から `array3` を呼び出しても、何の役にも立ちません:

```julia
function call_array3(fillval, n)
    A = array3(fillval, Val(n))
end
```

ここでは、同じ問題を再び作成しています：コンパイラは `n` が何であるかを推測できないため、`Val(n)` の*型*がわかりません。`Val` を使用しようとしますが、誤って使用すると、多くの状況でパフォーマンスが*悪化*する可能性があります。（上記のようなコードは、カーネル関数をより効率的にするために、実質的に `Val` を関数バリアトリックと組み合わせている状況でのみ使用されるべきです。）

`Val`の正しい使用例は次のとおりです：

```julia
function filter3(A::AbstractArray{T,N}) where {T,N}
    kernel = array3(1, Val(N))
    filter(A, kernel)
end
```

この例では、`N`がパラメータとして渡されるため、その「値」はコンパイラに知られています。基本的に、`Val(T)`は`T`がハードコーディングされたリテラル（`Val(3)`）であるか、すでに型ドメインで指定されている場合にのみ機能します。

## The dangers of abusing multiple dispatch (aka, more on types with values-as-parameters)

一度複数ディスパッチの重要性を理解すると、すべてにそれを使おうとする傾向があるのは理解できます。例えば、情報を保存するためにそれを使うことを想像するかもしれません。

```
struct Car{Make, Model}
    year::Int
    ...more fields...
end
```

そして、`Car{:Honda,:Accord}(year, args...)`のようなオブジェクトにディスパッチします。

これは、次のいずれかが真である場合に価値があるかもしれません：

  * 各 `Car` に対して CPU 集中型の処理が必要であり、コンパイル時に `Make` と `Model` を知っていると、効率が大幅に向上します。また、使用される異なる `Make` または `Model` の総数がそれほど多くない場合に限ります。
  * 同じタイプの `Car` の均質なリストを処理する必要があるため、すべてを `Array{Car{:Honda,:Accord},N}` に格納できます。

後者が成り立つとき、そのような均質な配列を処理する関数は生産的に特化できます：Juliaは各要素の型を事前に知っているため（コンテナ内のすべてのオブジェクトが同じ具体的な型を持つ）、関数がコンパイルされる際に正しいメソッド呼び出しを「参照」できるため（実行時にチェックする必要がなく）、リスト全体を処理するための効率的なコードを生成できます。

これらが成り立たない場合、利益を得られない可能性が高く、さらに「型の組み合わせ爆発」が逆効果になることがあります。もし `items[i+1]` が `item[i]` とは異なる型であれば、Julia は実行時に型を調べ、メソッドテーブルで適切なメソッドを検索し、型の交差を通じてどれが一致するかを決定し、まだJITコンパイルされていない場合はそれを行い、そして呼び出しを行います。要するに、あなたは完全な型システムとJITコンパイルの仕組みに、自分のコード内でスイッチ文や辞書の検索を実行させるように求めているのです。

いくつかのランタイムベンチマークが、(1) タイプディスパッチ、(2) 辞書ルックアップ、(3) "スイッチ" ステートメントを比較しています。詳細は [on the mailing list](https://groups.google.com/forum/#!msg/julia-users/jUMu9A3QKQQ/qjgVWr7vAwAJ) を参照してください。

おそらく、実行時の影響よりも悪いのはコンパイル時の影響です。Juliaは、異なる `Car{Make, Model}` ごとに特化した関数をコンパイルします。もし何百、何千ものそのような型がある場合、カスタムの `get_year` 関数から、Julia Baseの一般的な `push!` 関数まで、そのようなオブジェクトをパラメータとして受け取るすべての関数に対して、何百、何千ものバリアントがコンパイルされます。これらのそれぞれが、コンパイルされたコードのキャッシュのサイズ、内部のメソッドリストの長さなどを増加させます。値をパラメータとして使用することに対する過剰な熱意は、簡単に膨大なリソースを浪費する可能性があります。

## [Access arrays in memory order, along columns](@id man-performance-column-major)

Juliaの多次元配列は列優先順序で格納されます。これは、配列が1列ずつ積み重ねられることを意味します。これは、以下に示すように`vec`関数または構文`[:]`を使用して確認できます（配列が`[1 3 2 4]`の順序であることに注意してください、`[1 2 3 4]`ではありません）：

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> x[:]
4-element Vector{Int64}:
 1
 3
 2
 4
```

この配列の順序付けの規則は、Fortran、Matlab、Rなどの多くの言語で一般的です（いくつかの例を挙げると）。列優先順序の代替は行優先順序であり、これはCやPython（`numpy`）などの他の言語で採用されている規則です。配列の順序を覚えておくことは、配列をループする際に重要なパフォーマンス効果を持つ可能性があります。覚えておくべきルールは、列優先配列では最初のインデックスが最も速く変化するということです。基本的に、これは内側のループインデックスがスライス式の最初に現れる場合、ループが速くなることを意味します。`:`を使って配列にインデックスを付けることは、特定の次元内のすべての要素に反復的にアクセスする暗黙のループであることを念頭に置いてください。例えば、列を抽出する方が行を抽出するよりも速い場合があります。

次のような作り話の例を考えてみましょう。[`Vector`](@ref)を受け取り、入力ベクトルのコピーで埋められた正方形[`Matrix`](@ref)を返す関数を書きたいとします。行または列のどちらにこれらのコピーが埋められるかは重要ではないと仮定します（おそらく、残りのコードはそれに応じて簡単に適応できるでしょう）。少なくとも4つの方法（組み込みの[`repeat`](@ref)への推奨される呼び出しに加えて）でこれを実現できると考えられます。

```julia
function copy_cols(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for i = inds
        out[:, i] = x
    end
    return out
end

function copy_rows(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for i = inds
        out[i, :] = x
    end
    return out
end

function copy_col_row(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for col = inds, row = inds
        out[row, col] = x[row]
    end
    return out
end

function copy_row_col(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for row = inds, col = inds
        out[row, col] = x[col]
    end
    return out
end
```

これから、同じランダムな `10000` x `1` の入力ベクトルを使用して、これらの関数のそれぞれの実行時間を計測します。

```julia-repl
julia> x = randn(10000);

julia> fmt(f) = println(rpad(string(f)*": ", 14, ' '), @elapsed f(x))

julia> map(fmt, [copy_cols, copy_rows, copy_col_row, copy_row_col]);
copy_cols:    0.331706323
copy_rows:    1.799009911
copy_col_row: 0.415630047
copy_row_col: 1.721531501
```

`copy_cols` は `copy_rows` よりもはるかに速いことに注意してください。これは、`copy_cols` が `Matrix` の列ベースのメモリレイアウトを尊重し、1 列ずつ埋めるため、予想されることです。さらに、`copy_col_row` は `copy_row_col` よりもはるかに速いです。これは、スライス式に最初に現れる要素が最も内側のループと結びつくべきという私たちの経験則に従っているためです。

## Pre-allocating outputs

もしあなたの関数が `Array` や他の複雑な型を返す場合、メモリを割り当てる必要があるかもしれません。残念ながら、しばしば割り当てとその逆であるガーベジコレクションは、重大なボトルネックとなります。

時には、各関数呼び出しごとにメモリを割り当てる必要を回避するために、出力を事前に割り当てることができます。簡単な例として、比較してください。

```jldoctest prealloc
julia> function xinc(x)
           return [x, x+1, x+2]
       end;

julia> function loopinc()
           y = 0
           for i = 1:10^7
               ret = xinc(i)
               y += ret[2]
           end
           return y
       end;
```

with

```jldoctest prealloc
julia> function xinc!(ret::AbstractVector{T}, x::T) where T
           ret[1] = x
           ret[2] = x+1
           ret[3] = x+2
           nothing
       end;

julia> function loopinc_prealloc()
           ret = Vector{Int}(undef, 3)
           y = 0
           for i = 1:10^7
               xinc!(ret, i)
               y += ret[2]
           end
           return y
       end;
```

タイミング結果:

```jldoctest prealloc; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> @time loopinc()
  0.529894 seconds (40.00 M allocations: 1.490 GiB, 12.14% gc time)
50000015000000

julia> @time loopinc_prealloc()
  0.030850 seconds (6 allocations: 288 bytes)
50000015000000
```

プレアロケーションには他にも利点があります。たとえば、呼び出し元がアルゴリズムからの「出力」タイプを制御できるようにすることです。上記の例では、`SubArray`を渡すこともできましたが、[`Array`](@ref)を渡すことも可能でした。

極端に進めると、事前割り当てはコードを醜くする可能性があるため、パフォーマンス測定といくつかの判断が必要になる場合があります。しかし、「ベクトル化された」（要素ごとの）関数の場合、便利な構文 `x .= f.(y)` を使用して、テンポラリ配列なしでループを融合させたインプレース操作を行うことができます（詳細は [dot syntax for vectorizing functions](@ref man-vectorized) を参照してください）。

## [Use `MutableArithmetics` for more control over allocation for mutable arithmetic types](@id man-perftips-mutablearithmetics)

いくつかの [`Number`](@ref) サブタイプ、例えば [`BigInt`](@ref) や [`BigFloat`](@ref) は、[`mutable struct`](@ref) タイプとして実装されるか、可変コンポーネントを持つ場合があります。Julia `Base` の算術インターフェースは、通常、効率よりも便利さを選択するため、そのような場合にナイーブな方法で使用すると最適でないパフォーマンスを引き起こす可能性があります。一方で、[`MutableArithmetics`](https://juliahub.com/ui/Packages/General/MutableArithmetics) パッケージの抽象化は、そのようなタイプの可変性を利用して、必要な分だけを割り当てる高速なコードを書くことを可能にします。`MutableArithmetics` は、必要に応じて可変算術型の値を明示的にコピーすることも可能にします。`MutableArithmetics` はユーザーパッケージであり、Juliaプロジェクトとは提携していません。

## More dots: Fuse vectorized operations

ジュリアには、任意のスカラー関数を「ベクトル化された」関数呼び出しに、任意の演算子を「ベクトル化された」演算子に変換する特別な [dot syntax](@ref man-vectorized) があります。この特別なプロパティは、ネストされた「ドット呼び出し」が*融合*されることです：これは、構文レベルで単一のループに結合され、一時的な配列を割り当てることなく行われます。`.=` や類似の代入演算子を使用すると、結果は事前に割り当てられた配列にインプレースで保存することもできます（上記を参照）。

線形代数の文脈では、`vector + vector` や `vector * scalar` のような演算が定義されているにもかかわらず、代わりに `vector .+ vector` や `vector .* scalar` を使用することが有利な場合があります。なぜなら、結果として得られるループが周囲の計算と融合できるからです。例えば、次の2つの関数を考えてみましょう：

```jldoctest dotfuse
julia> f(x) = 3x.^2 + 4x + 7x.^3;

julia> fdot(x) = @. 3x^2 + 4x + 7x^3; # equivalent to 3 .* x.^2 .+ 4 .* x .+ 7 .* x.^3
```

両方の `f` と `fdot` は同じことを計算します。しかし、`fdot`（[`@.`](@ref @__dot__) マクロを使って定義された）は、配列に適用した場合、著しく速くなります：

```jldoctest dotfuse; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> x = rand(10^6);

julia> @time f(x);
  0.019049 seconds (16 allocations: 45.777 MiB, 18.59% gc time)

julia> @time fdot(x);
  0.002790 seconds (6 allocations: 7.630 MiB)

julia> @time f.(x);
  0.002626 seconds (8 allocations: 7.630 MiB)
```

つまり、`fdot(x)`は`f(x)`の10倍速く、メモリを1/6しか使用しません。なぜなら、`f(x)`の各`*`および`+`操作は新しい一時配列を割り当て、別のループで実行されるからです。この例では、`f.(x)`は`fdot(x)`と同じくらい速いですが、多くの文脈では、各ベクトル化操作のために別の関数を定義するよりも、式にいくつかのドットを散りばめる方が便利です。

## [Fewer dots: Unfuse certain intermediate broadcasts](@id man-performance-unfuse)

上記のドットループ融合は、高性能な操作を表現するための簡潔で慣用的なコードを可能にします。しかし、融合された操作はブロードキャストの各イテレーションで計算されることを忘れないことが重要です。これは、特に合成または多次元ブロードキャストが存在する場合に、ドット呼び出しを含む式が意図したよりも多くの回数関数を計算している可能性があることを意味します。例えば、行のユークリッドノルムが1のランダム行列を構築したいとしましょう。その場合、次のようなコードを書くかもしれません：

```
julia> x = rand(1000, 1000);

julia> d = sum(abs2, x; dims=2);

julia> @time x ./= sqrt.(d);
  0.002049 seconds (4 allocations: 96 bytes)
```

これで動作します。ただし、この式は実際には行 `x[i, :]` の *すべての* 要素に対して `sqrt(d[i])` を再計算するため、必要以上に多くの平方根が計算されることになります。ブロードキャストがどのインデックスを反復するかを正確に確認するには、融合式の引数に対して `Broadcast.combine_axes` を呼び出すことができます。これにより、エントリが反復の軸に対応する範囲のタプルが返されます。これらの範囲の長さの積が、融合操作への呼び出しの総数になります。

それにより、ブロードキャスト式のいくつかのコンポーネントが軸に沿って定数である場合—前の例での第二次元に沿った`sqrt`のように—、それらのコンポーネントを強制的に「非融合」させることによってパフォーマンスの向上の可能性があります。つまり、ブロードキャストされた操作の結果を事前に割り当て、その定数軸に沿ってキャッシュされた値を再利用することです。そのような潜在的なアプローチのいくつかは、一時変数を使用すること、ドット式のコンポーネントを`identity`でラップすること、または同等の内在的にベクトル化された（しかし非融合の）関数を使用することです。

```
julia> @time let s = sqrt.(d); x ./= s end;
  0.000809 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= identity(sqrt.(d));
  0.000608 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= map(sqrt, d);
  0.000611 seconds (4 allocations: 8.016 KiB)
```

これらのオプションのいずれも、割り当てのコストで約3倍のスピードアップをもたらします。大きなブロードキャスト可能なデータに対しては、このスピードアップは漸近的に非常に大きくなる可能性があります。

## [Consider using views for slices](@id man-performance-views)

Juliaでは、配列の「スライス」式 `array[1:5, :]` は、そのデータのコピーを作成します（代入の左辺にある場合を除き、ここでは `array[1:5, :] = ...` がその部分に対してインプレースで代入します）。スライスに対して多くの操作を行う場合、より小さな連続したコピーで作業する方が、元の配列にインデックスを付けるよりも効率的であるため、パフォーマンスにとって良いことがあります。一方で、スライスに対していくつかの単純な操作を行うだけの場合、割り当てとコピー操作のコストはかなり大きくなる可能性があります。

配列の「ビュー」を作成する代替手段があります。これは、実際に元の配列のデータをそのまま参照する配列オブジェクト（`SubArray`）であり、コピーを作成することなく行われます。（ビューに書き込むと、元の配列のデータも変更されます。）これは、[`view`](@ref)を呼び出すことで個々のスライスに対して行うことができます。また、より簡単には、[`@views`](@ref)をその式の前に置くことで、全体の式やコードブロックに対して行うことができます。例えば：

```jldoctest; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> fcopy(x) = sum(x[2:end-1]);

julia> @views fview(x) = sum(x[2:end-1]);

julia> x = rand(10^6);

julia> @time fcopy(x);
  0.003051 seconds (3 allocations: 7.629 MB)

julia> @time fview(x);
  0.001020 seconds (1 allocation: 16 bytes)
```

`fview`バージョンの関数の3倍のスピードアップとメモリ割り当ての減少の両方に注意してください。

## Copying data is not always bad

配列はメモリ内に連続して格納されており、CPUのベクトル化やキャッシュによるメモリアクセスの削減に寄与します。これらは、配列に列優先順序でアクセスすることが推奨される理由と同じです（上記参照）。不規則なアクセスパターンや非連続的なビューは、非連続的なメモリアクセスのために配列の計算を大幅に遅くする可能性があります。

不規則にアクセスされるデータを連続した配列にコピーしてから繰り返しアクセスすることで、大きな速度向上が得られることがあります。以下の例では、行列がランダムにシャッフルされたインデックスでアクセスされた後に乗算されます。プレーン配列にコピーすることで、コピーと割り当ての追加コストがあっても乗算が高速化されます。

```julia-repl
julia> using Random

julia> A = randn(3000, 3000);

julia> x = randn(2000);

julia> inds = shuffle(1:3000)[1:2000];

julia> function iterated_neural_network(A, x, depth)
           for _ in 1:depth
               x .= max.(0, A * x)
           end
           argmax(x)
       end

julia> @time iterated_neural_network(view(A, inds, inds), x, 10)
  0.324903 seconds (12 allocations: 157.562 KiB)
1569

julia> @time iterated_neural_network(A[inds, inds], x, 10)
  0.054576 seconds (13 allocations: 30.671 MiB, 13.33% gc time)
1569
```

十分なメモリがある場合、ビューを配列にコピーするコストは、連続した配列で繰り返し行う行列の乗算による速度向上によって上回られます。

## Consider StaticArrays.jl for small fixed-size vector/matrix operations

もしあなたのアプリケーションが多くの小さな（`< 100` 要素）固定サイズの配列を含む場合（つまり、サイズは実行前に知られている）、[StaticArrays.jl package](https://github.com/JuliaArrays/StaticArrays.jl)の使用を検討するかもしれません。このパッケージは、そのような配列を表現する方法を提供し、不要なヒープ割り当てを避け、コンパイラが配列の*サイズ*に特化したコードを生成できるようにします。例えば、ベクトル操作を完全に展開（ループを排除）し、要素をCPUレジスタに格納することが可能です。

例えば、2次元の幾何学で計算を行う場合、2成分のベクトルを使った多くの計算があるかもしれません。StaticArrays.jlの`SVector`型を使用することで、ベクトル`v`と`w`に対して`norm(3v - w)`のような便利なベクトル表記や演算を使用でき、コンパイラがコードを展開して`@inbounds hypot(3v[1]-w[1], 3v[2]-w[2])`と同等の最小限の計算にすることができます。

## Avoid string interpolation for I/O

ファイル（または他のI/Oデバイス）にデータを書き込む際に、余分な中間文字列を形成することはオーバーヘッドの原因となります。次のようにする代わりに：

```julia
println(file, "$a $b")
```

使用：

```julia
println(file, a, " ", b)
```

最初のバージョンのコードは文字列を形成し、それをファイルに書き込みます。一方、2番目のバージョンは値を直接ファイルに書き込みます。また、場合によっては文字列補間が読みづらくなることに注意してください。考慮してください：

```julia
println(file, "$(f(a))$(f(b))")
```

対決:

```julia
println(file, f(a), f(b))
```

## Optimize network I/O during parallel execution

リモート関数を並行して実行する場合:

```julia
using Distributed

responses = Vector{Any}(undef, nworkers())
@sync begin
    for (idx, pid) in enumerate(workers())
        @async responses[idx] = remotecall_fetch(foo, pid, args...)
    end
end
```

より速い:

```julia
using Distributed

refs = Vector{Any}(undef, nworkers())
for (idx, pid) in enumerate(workers())
    refs[idx] = @spawnat pid foo(args...)
end
responses = [fetch(r) for r in refs]
```

前者はすべてのワーカーに対して1回のネットワーク往復を行いますが、後者は2回のネットワーク呼び出しを行います - 最初は [`@spawnat`](@ref) によるもので、2回目は [`fetch`](@ref) によるものです（あるいは [`wait`](@ref) でも）。`4d61726b646f776e2e436f64652822222c202266657463682229_40726566`/`4d61726b646f776e2e436f64652822222c2022776169742229_40726566` は直列で実行されており、全体的にパフォーマンスが低下しています。

## Fix deprecation warnings

非推奨の関数は、関連する警告を一度だけ表示するために内部でルックアップを実行します。この追加のルックアップは、著しい遅延を引き起こす可能性があるため、非推奨の関数のすべての使用は、警告で示された通りに修正する必要があります。

## Tweaks

これらは、タイトな内部ループで役立つかもしれないいくつかの小さなポイントです。

  * 不必要な配列を避けてください。例えば、[`sum([x,y,z])`](@ref)の代わりに`x+y+z`を使用してください。
  * Use [`abs2(z)`](@ref) instead of [`abs(z)^2`](@ref) for complex `z`. In general, try to rewrite code to use [`abs2`](@ref) instead of [`abs`](@ref) for complex arguments.
  * Use [`div(x,y)`](@ref) for truncating division of integers instead of [`trunc(x/y)`](@ref), [`fld(x,y)`](@ref) instead of [`floor(x/y)`](@ref), and [`cld(x,y)`](@ref) instead of [`ceil(x/y)`](@ref).

## [Performance Annotations](@id man-performance-annotations)

時には、特定のプログラムの特性を約束することで、より良い最適化を有効にすることができます。

  * [`@inbounds`](@ref)を使用して、式内の配列境界チェックを排除します。これを行う前に確信を持ってください。もし添字が境界外であれば、クラッシュや静かな破損が発生する可能性があります。
  * [`@fastmath`](@ref)を使用して、実数に対して正しいが、IEEE数に対しては違いをもたらす浮動小数点最適化を許可します。これを行う際は注意が必要です。数値結果が変わる可能性があります。これはclangの`-ffast-math`オプションに対応しています。
  * [`@simd`](@ref)を`for`ループの前に書いて、反復が独立しており、順序を変更できることを約束します。多くの場合、Juliaは`@simd`マクロなしで自動的にコードをベクトル化できますが、これはそのような変換が違法である場合、特に浮動小数点の再結合を許可し、依存メモリアクセスを無視する場合（`@simd ivdep`を含む）にのみ有益です。依存する反復を持つループに誤って`@simd`を注釈付けすると、予期しない結果をもたらす可能性があるため、`@simd`を主張する際には非常に注意してください。特に、いくつかの`AbstractArray`サブタイプに対する`setindex!`は、反復順序に本質的に依存していることに注意してください。**この機能は実験的であり、将来のJuliaのバージョンで変更されるか、消える可能性があります。**

1:nを使ってAbstractArrayにインデックスを付ける一般的な慣用句は、配列が非標準のインデックス付けを使用している場合、安全ではなく、境界チェックがオフになっているとセグメンテーションフォルトを引き起こす可能性があります。代わりに`LinearIndices(x)`または`eachindex(x)`を使用してください（詳細は[Arrays with custom indices](@ref man-custom-indices)を参照）。

!!! note
    `@simd`は最も内側の`for`ループの直前に置く必要がありますが、`@inbounds`と`@fastmath`は、単一の式や、ネストされたコードブロック内に現れるすべての式に適用できます。例えば、`@inbounds begin`や`@inbounds for ...`を使用することができます。


ここに `@inbounds` と `@simd` マークアップの両方を使用した例があります（ここでは、最適化プログラムがあまり賢くなりすぎてベンチマークを妨害しないように `@noinline` を使用しています）：

```julia
@noinline function inner(x, y)
    s = zero(eltype(x))
    for i=eachindex(x)
        @inbounds s += x[i]*y[i]
    end
    return s
end

@noinline function innersimd(x, y)
    s = zero(eltype(x))
    @simd for i = eachindex(x)
        @inbounds s += x[i] * y[i]
    end
    return s
end

function timeit(n, reps)
    x = rand(Float32, n)
    y = rand(Float32, n)
    s = zero(Float64)
    time = @elapsed for j in 1:reps
        s += inner(x, y)
    end
    println("GFlop/sec        = ", 2n*reps / time*1E-9)
    time = @elapsed for j in 1:reps
        s += innersimd(x, y)
    end
    println("GFlop/sec (SIMD) = ", 2n*reps / time*1E-9)
end

timeit(1000, 1000)
```

2.4GHzのIntel Core i5プロセッサを搭載したコンピュータでは、これが生成されます：

```
GFlop/sec        = 1.9467069505224963
GFlop/sec (SIMD) = 17.578554163920018
```

(`GFlop/sec`はパフォーマンスを測定し、大きな数値がより良いことを示します。)

ここに3種類のマークアップを使用した例があります。このプログラムは、まず1次元配列の有限差分を計算し、その結果のL2ノルムを評価します：

```julia
function init!(u::Vector)
    n = length(u)
    dx = 1.0 / (n-1)
    @fastmath @inbounds @simd for i in 1:n #by asserting that `u` is a `Vector` we can assume it has 1-based indexing
        u[i] = sin(2pi*dx*i)
    end
end

function deriv!(u::Vector, du)
    n = length(u)
    dx = 1.0 / (n-1)
    @fastmath @inbounds du[1] = (u[2] - u[1]) / dx
    @fastmath @inbounds @simd for i in 2:n-1
        du[i] = (u[i+1] - u[i-1]) / (2*dx)
    end
    @fastmath @inbounds du[n] = (u[n] - u[n-1]) / dx
end

function mynorm(u::Vector)
    n = length(u)
    T = eltype(u)
    s = zero(T)
    @fastmath @inbounds @simd for i in 1:n
        s += u[i]^2
    end
    @fastmath @inbounds return sqrt(s)
end

function main()
    n = 2000
    u = Vector{Float64}(undef, n)
    init!(u)
    du = similar(u)

    deriv!(u, du)
    nu = mynorm(du)

    @time for i in 1:10^6
        deriv!(u, du)
        nu = mynorm(du)
    end

    println(nu)
end

main()
```

2.7 GHzのIntel Core i7プロセッサを搭載したコンピュータでは、これが生成されます：

```
$ julia wave.jl;
  1.207814709 seconds
4.443986180758249

$ julia --math-mode=ieee wave.jl;
  4.487083643 seconds
4.443986180758249
```

ここでは、オプション `--math-mode=ieee` が `@fastmath` マクロを無効にするため、結果を比較できるようになります。

この場合、`@fastmath`によるスピードアップは約3.7倍です。これは異常に大きい値であり、一般的にはスピードアップはより小さくなります。（この特定の例では、ベンチマークの作業セットがプロセッサのL1キャッシュに収まるほど小さいため、メモリアクセスのレイテンシは影響を与えず、計算時間はCPUの使用に支配されます。多くの実世界のプログラムでは、これは当てはまりません。）また、この場合、この最適化は結果を変更しませんが、一般的には結果はわずかに異なるでしょう。特に数値的に不安定なアルゴリズムの場合、結果は非常に異なることがあります。

アノテーション `@fastmath` は浮動小数点表現を再配置します。例えば、評価の順序を変更したり、特定の特別なケース（inf、nan）が発生しないと仮定したりします。この場合（およびこの特定のコンピュータ上では）、主な違いは、関数 `deriv` 内の式 `1 / (2*dx)` がループの外に持ち上げられることです（つまり、ループの外で計算されます）。これは、`idx = 1 / (2*dx)` と書いたかのようです。ループ内では、式 `... / (2*dx)` は `... * idx` となり、評価がはるかに速くなります。もちろん、コンパイラによって適用される実際の最適化と、結果として得られるスピードアップは、ハードウェアに非常に依存します。生成されたコードの変更を調べるには、Juliaの [`code_native`](@ref) 関数を使用できます。

`@fastmath`は、計算中に`NaN`が発生しないことも前提としているため、驚くべき動作を引き起こす可能性があります。

```julia-repl
julia> f(x) = isnan(x);

julia> f(NaN)
true

julia> f_fast(x) = @fastmath isnan(x);

julia> f_fast(NaN)
false
```

## Treat Subnormal Numbers as Zeros

サブノーマル数（以前は [denormal numbers](https://en.wikipedia.org/wiki/Denormal_number) と呼ばれていました）は、多くの文脈で有用ですが、一部のハードウェアではパフォーマンスのペナルティが発生します。呼び出し [`set_zero_subnormals(true)`](@ref) は、浮動小数点演算がサブノーマルな入力または出力をゼロとして扱うことを許可し、これにより一部のハードウェアでのパフォーマンスが向上する可能性があります。呼び出し [`set_zero_subnormals(false)`](@ref) は、サブノーマル数に対して厳密なIEEEの動作を強制します。

以下は、サブノーマルが一部のハードウェアでパフォーマンスに顕著な影響を与える例です：

```julia
function timestep(b::Vector{T}, a::Vector{T}, Δt::T) where T
    @assert length(a)==length(b)
    n = length(b)
    b[1] = 1                            # Boundary condition
    for i=2:n-1
        b[i] = a[i] + (a[i-1] - T(2)*a[i] + a[i+1]) * Δt
    end
    b[n] = 0                            # Boundary condition
end

function heatflow(a::Vector{T}, nstep::Integer) where T
    b = similar(a)
    for t=1:div(nstep,2)                # Assume nstep is even
        timestep(b,a,T(0.1))
        timestep(a,b,T(0.1))
    end
end

heatflow(zeros(Float32,10),2)           # Force compilation
for trial=1:6
    a = zeros(Float32,1000)
    set_zero_subnormals(iseven(trial))  # Odd trials use strict IEEE arithmetic
    @time heatflow(a,1000)
end
```

これは次のような出力を生成します。

```
  0.002202 seconds (1 allocation: 4.063 KiB)
  0.001502 seconds (1 allocation: 4.063 KiB)
  0.002139 seconds (1 allocation: 4.063 KiB)
  0.001454 seconds (1 allocation: 4.063 KiB)
  0.002115 seconds (1 allocation: 4.063 KiB)
  0.001455 seconds (1 allocation: 4.063 KiB)
```

各偶数イテレーションが著しく速いことに注意してください。

この例は、多くの非正規数を生成します。なぜなら、`a` の値が指数的に減少する曲線になり、時間が経つにつれて徐々に平坦になっていくからです。

サブノーマルをゼロとして扱うことは注意が必要です。なぜなら、そうすることでいくつかの恒等式が破壊されるからです。例えば、`x-y == 0` は `x == y` を意味します。

```jldoctest
julia> x = 3f-38; y = 2f-38;

julia> set_zero_subnormals(true); (x - y, x == y)
(0.0f0, false)

julia> set_zero_subnormals(false); (x - y, x == y)
(1.0000001f-38, false)
```

いくつかのアプリケーションでは、サブノーマル数をゼロにする代わりに、わずかなノイズを注入する方法があります。たとえば、`a`をゼロで初期化するのではなく、次のように初期化します：

```julia
a = rand(Float32,1000) * 1.f-9
```

## [[`@code_warntype`](@ref)](@id man-code-warntype)

マクロ [`@code_warntype`](@ref) （またはその関数バリアント [`code_warntype`](@ref)）は、型に関連する問題を診断するのに役立つことがあります。以下はその例です：

```julia-repl
julia> @noinline pos(x) = x < 0 ? 0 : x;

julia> function f(x)
           y = pos(x)
           return sin(y*x + 1)
       end;

julia> @code_warntype f(3.2)
MethodInstance for f(::Float64)
  from f(x) @ Main REPL[9]:1
Arguments
  #self#::Core.Const(f)
  x::Float64
Locals
  y::Union{Float64, Int64}
Body::Float64
1 ─      (y = Main.pos(x))
│   %2 = (y * x)::Float64
│   %3 = (%2 + 1)::Float64
│   %4 = Main.sin(%3)::Float64
└──      return %4
```

Interpreting the output of [`@code_warntype`](@ref), like that of its cousins [`@code_lowered`](@ref), [`@code_typed`](@ref), [`@code_llvm`](@ref), and [`@code_native`](@ref), takes a little practice. Your code is being presented in form that has been heavily digested on its way to generating compiled machine code. Most of the expressions are annotated by a type, indicated by the `::T` (where `T` might be [`Float64`](@ref), for example). The most important characteristic of [`@code_warntype`](@ref) is that non-concrete types are displayed in red; since this document is written in Markdown, which has no color, in this document, red text is denoted by uppercase.

関数の推測された戻り値の型は `Body::Float64` として表示されています。次の行は、JuliaのSSA IR形式での `f` の本体を表しています。番号付きのボックスはラベルであり、コード内のジャンプ（`goto`を介して）のターゲットを表しています。本体を見てみると、最初に `pos` が呼び出され、その戻り値は大文字で示された `Union` 型 `Union{Float64, Int64}` として推測されています。これは、具体的な型ではないため、入力型に基づいて `pos` の正確な戻り値の型を知ることができないことを意味します。しかし、`y*x` の結果は、`y` が `Float64` であろうと `Int64` であろうと `Float64` になります。最終的な結果として、`f(x::Float64)` は出力において型不安定ではなく、いくつかの中間計算が型不安定であっても問題ありません。

この情報をどのように使用するかはあなた次第です。明らかに、`pos`を型安定に固定するのが最も良いでしょう。そうすれば、`f`内のすべての変数が具体的になり、そのパフォーマンスは最適になります。しかし、この種の*一時的な*型不安定性がそれほど重要でない場合もあります。たとえば、`pos`が単独で使用されない場合、`f`の出力が型安定であること（[`Float64`](@ref)入力に対して）は、後のコードが型不安定性の影響を受けるのを防ぎます。これは、型不安定性を修正するのが難しいまたは不可能な場合に特に関連します。そのような場合、上記のヒント（たとえば、型注釈を追加することや関数を分割すること）は、型不安定性からの「損害」を抑えるための最良のツールです。また、Julia Baseにも型不安定な関数があることに注意してください。たとえば、関数[`findfirst`](@ref)は、キーが見つかった配列のインデックスを返し、見つからなかった場合は`nothing`を返します。これは明確な型不安定性です。重要である可能性のある型不安定性を見つけやすくするために、`missing`または`nothing`を含む`Union`は赤ではなく黄色で色分けされています。

以下の例は、非葉タイプを含むとマークされた式を解釈するのに役立つかもしれません：

  * `Body::Union{T1,T2})` で始まる関数本体

      * 解釈: 不安定な戻り値の型を持つ関数
      * 提案: 戻り値の型を安定させるために、注釈を付ける必要があってもそうしてください。
  * `invoke Main.g(%%x::Int64)::Union{Float64, Int64}`

      * 解釈: 型が不安定な関数 `g` への呼び出し。
      * 提案: 関数を修正するか、必要に応じて戻り値に注釈を付けてください。
  * `invoke Base.getindex(%%x::Array{Any,1}, 1::Int64)::Any`

      * 解釈: 型が不適切な配列の要素にアクセスすること
      * 提案: より明確に定義された型の配列を使用するか、必要に応じて個々の要素アクセスの型を注釈してください。
  * `Base.getfield(%%x, :(:data))::Array{Float64,N} where N`

      * 解釈：リーフ型でないタイプのフィールドを取得すること。ここで、`x`のタイプ、例えば`ArrayContainer`は、フィールド`data::Array{T}`を持っていました。しかし、`Array`は具体的なタイプであるために次元`N`も必要です。
      * 提案: `Array{T,3}`や`Array{T,N}`のような具体的な型を使用してください。ここで、`N`は現在`ArrayContainer`のパラメータです。

## [Performance of captured variable](@id man-performance-captured)

次の例を考えて、内部関数を定義します：

```julia
function abmult(r::Int)
    if r < 0
        r = -r
    end
    f = x -> x * r
    return f
end
```

関数 `abmult` は、引数を `r` の絶対値で乗算する関数 `f` を返します。`f` に割り当てられた内部関数は「クロージャ」と呼ばれます。内部関数は、言語によって `do` ブロックやジェネレーター式にも使用されます。

このスタイルのコードは、言語に対してパフォーマンスの課題を提示します。パーサーは、これを低レベルの命令に翻訳する際に、内部関数を別のコードブロックに抽出することによって、上記のコードを大幅に再編成します。内部関数とその囲むスコープで共有される「キャプチャされた」変数（例えば `r`）も、内部関数と外部関数の両方からアクセス可能なヒープに割り当てられた「ボックス」に抽出されます。これは、言語が内部スコープの `r` が外部スコープの `r` と同一でなければならないと規定しているためであり、外部スコープ（または別の内部関数）が `r` を変更した後でも同様です。

前の段落での議論は「パーサー」に言及しており、これは `abmult` を含むモジュールが最初にロードされる際に行われるコンパイルのフェーズを指します。これは、最初に呼び出される後のフェーズとは対照的です。パーサーは `Int` が固定型であることや、`r = -r` という文が `Int` を別の `Int` に変換することを「知っている」わけではありません。型推論の魔法はコンパイルの後のフェーズで行われます。

したがって、パーサーは `r` が固定の型（`Int`）を持っていることや、内部関数が作成された後に `r` の値が変わらないこと（そのためボックスが不要であること）を知りません。したがって、パーサーは `Any` のような抽象型を持つオブジェクトを保持するボックスのコードを生成します。これにより、`r` の各出現に対して実行時型ディスパッチが必要になります。これは、上記の関数に `@code_warntype` を適用することで確認できます。ボクシングと実行時型ディスパッチの両方がパフォーマンスの低下を引き起こす可能性があります。

もしキャプチャされた変数がパフォーマンスに重要なコードセクションで使用される場合、以下のヒントがその使用をパフォーマンス向上に役立ちます。まず、キャプチャされた変数がその型を変更しないことが分かっている場合、これは型注釈を使って明示的に宣言できます（変数に対して、右辺ではなく）：

```julia
function abmult2(r0::Int)
    r::Int = r0
    if r < 0
        r = -r
    end
    f = x -> x * r
    return f
end
```

型注釈は、パーサーがボックス内のオブジェクトに具体的な型を関連付けることができるため、キャプチャによって失われたパフォーマンスを部分的に回復します。さらに、キャプチャされた変数が（クロージャが作成された後に再代入されないため）全くボックス化される必要がない場合、次のように `let` ブロックで示すことができます。

```julia
function abmult3(r::Int)
    if r < 0
        r = -r
    end
    f = let r = r
            x -> x * r
    end
    return f
end
```

`let` ブロックは、新しい変数 `r` を作成し、そのスコープは内部関数のみに限定されます。2 番目の技術は、キャプチャされた変数が存在する場合でも、完全な言語パフォーマンスを回復します。これはコンパイラの急速に進化している側面であり、将来のリリースではパフォーマンスを達成するためにこの程度のプログラマーの注釈が必要なくなる可能性が高いことに注意してください。その間、[FastClosures](https://github.com/c42f/FastClosures.jl) のようなユーザー提供のパッケージが、`abmult3` のように `let` ステートメントの挿入を自動化します。

## [Multithreading and linear algebra](@id man-multithreading-linear-algebra)

このセクションは、各スレッドで線形代数演算を行うマルチスレッドのJuliaコードに適用されます。実際、これらの線形代数演算はBLAS / LAPACK呼び出しを含み、これら自体もマルチスレッドです。この場合、2つの異なるタイプのマルチスレッドによってコアが過剰に割り当てられないようにする必要があります。

Juliaは線形代数のために独自のOpenBLASのコピーをコンパイルして使用しており、そのスレッド数は環境変数`OPENBLAS_NUM_THREADS`によって制御されます。これは、Juliaを起動する際のコマンドラインオプションとして設定することも、Juliaセッション中に`BLAS.set_num_threads(N)`を使用して変更することもできます（サブモジュール`BLAS`は`using LinearAlgebra`によってエクスポートされます）。現在の値は`BLAS.get_num_threads()`で取得できます。

ユーザーが何も指定しない場合、JuliaはOpenBLASスレッドの数に対して合理的な値を選ぼうとします（例：プラットフォーム、Juliaのバージョンなどに基づいて）。ただし、一般的には値を手動で確認し設定することが推奨されます。OpenBLASの動作は以下の通りです：

  * `OPENBLAS_NUM_THREADS=1` の場合、OpenBLASは呼び出し元のJuliaスレッドを使用します。つまり、計算を実行するJuliaスレッドの中で「存在する」ことになります。
  * `OPENBLAS_NUM_THREADS=N>1` の場合、OpenBLAS は独自のスレッドプールを作成し、管理します（合計で `N`）。すべての Julia スレッドで共有されるのは、1 つの OpenBLAS スレッドプールだけです。

Juliaをマルチスレッドモードで`JULIA_NUM_THREADS=X`で起動するときは、一般的に`OPENBLAS_NUM_THREADS=1`に設定することが推奨されます。上記の動作を考慮すると、BLASスレッドの数を`N>1`に増やすと、特に`N<<X`の場合、パフォーマンスが悪化する可能性が非常に高いです。しかし、これはあくまで経験則であり、各スレッド数を設定する最良の方法は、特定のアプリケーションで実験することです。

## [Alternative linear algebra backends](@id man-backends-linear-algebra)

OpenBLASの代替として、線形代数のパフォーマンスを向上させるための他のバックエンドがいくつか存在します。代表的な例としては [MKL.jl](https://github.com/JuliaLinearAlgebra/MKL.jl) と [AppleAccelerate.jl](https://github.com/JuliaMath/AppleAccelerate.jl) があります。

これらは外部パッケージであるため、ここでは詳細については議論しません。それぞれのドキュメントを参照してください（特に、マルチスレッドに関してOpenBLASとは異なる動作をするためです）。

## Execution latency, package loading and package precompiling time

### Reducing time to first plot etc.

最初にjuliaメソッドが呼び出されると、それ（およびそれが呼び出すメソッド、または静的に決定できるメソッド）はコンパイルされます。[`@time`](@ref)マクロファミリーはこれを示しています。

```
julia> foo() = rand(2,2) * rand(2,2)
foo (generic function with 1 method)

julia> @time @eval foo();
  0.252395 seconds (1.12 M allocations: 56.178 MiB, 2.93% gc time, 98.12% compilation time)

julia> @time @eval foo();
  0.000156 seconds (63 allocations: 2.453 KiB)
```

`@time @eval`はコンパイル時間を測定するのに優れていることに注意してください。なぜなら、[`@eval`](@ref)なしでは、タイミングが始まる前にコンパイルがすでに行われている可能性があるからです。

パッケージを開発する際、*プリコンパイル*を使用することで、ユーザーの体験を向上させることができるかもしれません。これにより、パッケージを使用する際に、ユーザーが使用するコードはすでにコンパイルされています。パッケージコードを効果的にプリコンパイルするためには、[`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/)を使用して、プリコンパイル時に典型的なパッケージ使用を代表する「プリコンパイルワークロード」を実行することをお勧めします。これにより、ネイティブコンパイルされたコードがパッケージの`pkgimage`キャッシュにキャッシュされ、こうした使用に対する「初回実行までの時間」（TTFXと呼ばれることが多い）を大幅に短縮します。

[`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/) ワークロードは無効にすることができ、場合によってはプリコンパイルに余分な時間をかけたくない場合に、Preferencesを介して構成することもできます。これは、パッケージの開発中に該当することがあります。

### Reducing package loading time

パッケージの読み込みにかかる時間を短く保つことは通常有益です。パッケージ開発者にとっての一般的な良い実践には以下が含まれます：

1. 依存関係は本当に必要なものだけに減らしましょう。他のパッケージとの相互運用性をサポートするために、[package extensions](@ref)の使用を検討してください。これにより、基本的な依存関係が膨らむことを避けられます。
2. [`__init__()`](@ref) 関数の使用は、代替手段がない場合を除き避けてください。特に、多くのコンパイルを引き起こす可能性があるものや、実行に時間がかかるものは避けるべきです。
3. 可能な場合は、依存関係およびパッケージコードから [invalidations](https://julialang.org/blog/2020/08/invalidations/) を修正してください。

ツール [`@time_imports`](@ref) は、REPL で上記の要因を確認するのに役立ちます。

```julia-repl
julia> @time @time_imports using Plots
      0.5 ms  Printf
     16.4 ms  Dates
      0.7 ms  Statistics
               ┌ 23.8 ms SuiteSparse_jll.__init__() 86.11% compilation time (100% recompilation)
     90.1 ms  SuiteSparse_jll 91.57% compilation time (82% recompilation)
      0.9 ms  Serialization
               ┌ 39.8 ms SparseArrays.CHOLMOD.__init__() 99.47% compilation time (100% recompilation)
    166.9 ms  SparseArrays 23.74% compilation time (100% recompilation)
      0.4 ms  Statistics → SparseArraysExt
      0.5 ms  TOML
      8.0 ms  Preferences
      0.3 ms  PrecompileTools
      0.2 ms  Reexport
... many deps omitted for example ...
      1.4 ms  Tar
               ┌ 73.8 ms p7zip_jll.__init__() 99.93% compilation time (100% recompilation)
     79.4 ms  p7zip_jll 92.91% compilation time (100% recompilation)
               ┌ 27.7 ms GR.GRPreferences.__init__() 99.77% compilation time (100% recompilation)
     43.0 ms  GR 64.26% compilation time (100% recompilation)
               ┌ 2.1 ms Plots.__init__() 91.80% compilation time (100% recompilation)
    300.9 ms  Plots 0.65% compilation time (100% recompilation)
  1.795602 seconds (3.33 M allocations: 190.153 MiB, 7.91% gc time, 39.45% compilation time: 97% of which was recompilation)

```

この例では、複数のパッケージが読み込まれていることに注意してください。いくつかは `__init__()` 関数を持ち、その中にはコンパイルを引き起こすものや再コンパイルを引き起こすものがあります。再コンパイルは、以前のパッケージがメソッドを無効にすることによって引き起こされます。そして、このような場合、次のパッケージが `__init__()` 関数を実行するときに、コードが実行される前に再コンパイルが発生することがあります。

さらに、`SparseArrays`が依存関係ツリーにあるため、`Statistics`拡張機能`SparseArraysExt`が有効になっていることに注意してください。すなわち、`0.4 ms  Statistics → SparseArraysExt`を参照してください。

このレポートは、依存関係のロード時間のコストがそれがもたらす機能に見合うものかどうかを見直す良い機会を提供します。また、`Pkg`ユーティリティの`why`を使用して、間接依存関係が存在する理由を報告することもできます。

```
(CustomPackage) pkg> why FFMPEG_jll
  Plots → FFMPEG → FFMPEG_jll
  Plots → GR → GR_jll → FFMPEG_jll
```

また、パッケージがもたらす間接的な依存関係を確認するには、`pkg> rm` コマンドでパッケージを削除し、マニフェストから削除された依存関係を確認した後、`pkg> undo` コマンドで変更を元に戻すことができます。

もしロード時間が遅い `__init__()` メソッドによるコンパイルに支配されている場合、何がコンパイルされているかを特定するための冗長な方法は、julia 引数 `--trace-compile=stderr` を使用することです。これにより、メソッドがコンパイルされるたびに [`precompile`](@ref) ステートメントが報告されます。たとえば、完全なセットアップは次のようになります：

```
$ julia --startup-file=no --trace-compile=stderr
julia> @time @time_imports using CustomPackage
...
```

`--startup-file=no`は、`startup.jl`にあるパッケージからテストを隔離するのに役立ちます。

再コンパイルの理由に関するさらなる分析は、[`SnoopCompile`](https://github.com/timholy/SnoopCompile.jl) パッケージを使用することで達成できます。

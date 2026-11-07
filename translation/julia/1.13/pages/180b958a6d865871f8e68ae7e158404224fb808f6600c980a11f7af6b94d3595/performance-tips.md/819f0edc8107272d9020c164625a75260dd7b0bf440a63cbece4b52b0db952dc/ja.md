# [Performance Tips](@id man-performance-tips)

以下の節では、Juliaコードをできるだけ高速に実行するために役立つ手法をいくつか簡単に紹介します。

## [Table of contents](@id man-performance-tips-toc)

```@contents
Pages = ["performance-tips.md"]
Depth = 3
```

## General advice

### Performance critical code should be inside a function

性能が重要なコードは、必ず関数の中に記述してください。Juliaのコンパイラの仕組み上、関数内のコードはトップレベルのコードよりもはるかに高速に実行される傾向があります。

関数の利用は、性能面で重要なだけではありません。関数にすると再利用やテストが容易になり、どのような処理を行い、その入力と出力が何であるかも明確になります。[Write functions, not just scripts](@ref)は、Juliaのスタイルガイドでも推奨されています。

関数ではグローバル変数を直接操作するのではなく、引数を受け取るようにしてください。次の項目を参照してください。

### Avoid untyped global variables

型が指定されていないグローバル変数の値はいつでも変わる可能性があり、その結果、型も変わる可能性があります。そのため、コンパイラはグローバル変数を使うコードを最適化しにくくなります。これは、型を値として持つ変数、つまりグローバルレベルの型エイリアスにも当てはまります。可能な限り、変数はローカル変数にするか、関数の引数として渡してください。

グローバルな名前は定数であることが多く、定数として宣言すると性能が大幅に向上します。

```julia
const DEFAULT_VAL = 0
```

定数ではないグローバル変数の型が常に同じであるとわかっている場合は、[the type should be annotated](@ref man-typed-globals)。一方、`const`のグローバル変数は初期値から型が推論されるため、型注釈は不要です。

型が指定されていないグローバル変数を使用する場合でも、使用箇所で型注釈を付けることで最適化できます。

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

関数に引数を渡す方が、よりよい書き方です。コードの再利用性が高まり、入力と出力も明確になります。

!!! note
    REPL内のコードはすべてグローバルスコープで評価されるため、トップレベルで定義して値を代入した変数は**グローバル**変数になります。モジュール内のトップレベルスコープで定義された変数もグローバル変数です。


次のREPLセッションのコードは、

```jldoctest
julia> x = 1.0
1.0
```

次と同等です。

```jldoctest
julia> global x = 1.0
1.0
```

したがって、これまでに説明した性能上の問題がすべて当てはまります。

### Measure performance with [`@time`](@ref) and pay attention to memory allocation

性能測定に便利なツールが[`@time`](@ref)マクロです。ここでは、先ほどのグローバル変数を使った例を、今度は型注釈を取り除いて再実行します。

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

最初の呼び出し（`@time sum_global()`）では、関数がコンパイルされます。（このセッションで[`@time`](@ref)をまだ使っていなければ、時間測定に必要な関数もコンパイルされます。）この実行結果をそのまま性能の指標にしないでください。2回目の実行では、時間だけでなく、かなりの量のメモリが割り当てられたことも報告されています。ここでは64ビット浮動小数点数のベクトルの全要素を合計しているだけなので、（ヒープ）メモリの割り当ては不要なはずです。

ここで明確にしておくと、`@time`が報告するのは、具体的には*ヒープ*割り当てです。ヒープ割り当ては通常、可変オブジェクトや、可変長コンテナの作成・拡張に必要となります。たとえば、`Array`や`Dict`、文字列、実行時にしか型がわからない「型不安定」なオブジェクトなどです。このようなメモリブロックの割り当て（または解放）には、libcへの高コストな関数呼び出し（たとえばCの`malloc`を介した呼び出し）が必要になることがあり、ガベージコレクションのための追跡も必要です。これに対し、数値（多倍長数を除く）、タプル、不変の`struct`などの不変な値は、スタックやCPUレジスタなどにはるかに低コストで格納できるため、通常はその「割り当て」の性能コストを気にする必要はありません。

予期しないメモリ割り当ては、ほぼ常にコードに何らかの問題がある兆候です。多くの場合、型安定性の問題か、小さな一時配列を多数作成していることが原因です。そのため、割り当てそのものに加え、関数に対して生成されたコードも最適とは程遠い可能性が非常に高いといえます。このような兆候を重く受け止め、以下の助言に従ってください。

Juliaのメモリ管理とガベージコレクションの詳細については、[Memory Management and Garbage Collection](@ref man-memory-management)を参照してください。

この例では、型不安定なグローバル変数`x`の使用がメモリ割り当ての原因です。代わりに`x`を関数の引数として渡すと、メモリ割り当ては発生しなくなり、初回の呼び出し後は大幅に高速になります（以下で報告されている残りの割り当ては、`@time`マクロをグローバルスコープで実行したためです）。

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

ここで見られる1回の割り当ては、`@time`マクロ自体をグローバルスコープで実行したことによるものです。代わりに関数内で時間を測定すると、実際に割り当てが行われていないことを確認できます。

```jldoctest sumarg; filter = r"[0-9\.]+ seconds"
julia> time_sum(x) = @time sum_arg(x);

julia> time_sum(x)
  0.000002 seconds
523.0007221951678
```

状況によっては、関数の処理の一部としてメモリ割り当てが必要になり、上の単純な説明だけでは済まなくなります。その場合は、後述の[tools](@ref tools)のいずれかを使って問題を診断するか、割り当てとアルゴリズムの処理を分離した関数を書くことを検討してください（[Pre-allocate outputs](@ref)を参照）。

!!! note
    より本格的なベンチマークには、[BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl)パッケージの利用を検討してください。このパッケージは、ノイズを減らすために関数を複数回評価するなどの機能を備えています。


### Break functions into multiple definitions

関数を多数の小さな定義に分けて書くと、コンパイラは最も適切なコードを直接呼び出したり、インライン化したりできます。

次は、本来は複数の定義に分けるべき「複合的な関数」の例です。

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

これは、次のように、より簡潔かつ効率的に書けます。

```julia
mynorm(x::Vector) = sqrt(real(dot(x, x)))
mynorm(A::Matrix) = maximum(svdvals(A))
```

ただし、`mynorm`の例のようなコードでも、コンパイラは実行されない分岐をかなり効率よく最適化で取り除けることに留意してください。

### [Tools](@id tools)

Juliaとそのパッケージエコシステムには、問題の診断やコードの性能改善に役立つツールがあります。

  * [Profiling](@ref)を使うと、実行中のコードの性能を測定し、ボトルネックとなっている行を特定できます。複雑なプロジェクトでは、[ProfileView](https://github.com/timholy/ProfileView.jl)パッケージでプロファイリング結果を可視化すると役立ちます。
  * [JET](https://github.com/aviatesk/JET.jl)パッケージは、コードによくある性能上の問題を見つけるのに役立ちます。
  * [`@time`](@ref)、[`@allocated`](@ref)、またはプロファイラ（ガベージコレクションルーチンの呼び出しを通じて）が報告する、予想外に多量のメモリ割り当ては、コードに問題がある可能性を示しています。割り当ての理由がほかに見当たらなければ、型の問題を疑ってください。また、`--track-allocation=user`オプション付きでJuliaを起動し、生成される`*.mem`ファイルを調べることで、割り当ての発生箇所を確認できます。[Memory allocation analysis](@ref)を参照してください。
  * `@code_warntype`はコードの表現を生成し、型が不確定になる式を見つけるのに役立ちます。後述の[`@code_warntype`](@ref)を参照してください。

## Type inference

型宣言が省略可能な多くの言語では、宣言を追加することがコードを高速化する主な手段です。Juliaでは*そうではありません*。Juliaのコンパイラは通常、すべての関数引数、ローカル変数、式の型を把握しています。ただし、宣言が役立つ特定のケースはいくつかあります。

### [Avoid containers with abstract type parameters](@id man-performance-abstract-container)

配列を含むパラメトリック型を扱う場合は、可能な限り、抽象型を型パラメータに使わないようにするのが最善です。

次の例を考えてみましょう。

```jldoctest
julia> a = Real[]
Real[]

julia> push!(a, 1); push!(a, 2.0); push!(a, π)
3-element Vector{Real}:
 1
 2.0
 π = 3.1415926535897...
```

`a`は抽象型[`Real`](@ref)の配列なので、あらゆる`Real`の値を格納できなければなりません。`Real`オブジェクトのサイズや構造はさまざまであるため、`a`は、個別に割り当てられた`Real`オブジェクトへのポインタの配列として表現する必要があります。一方、`a`に格納できる数値を、たとえば[`Float64`](@ref)のような同じ型のものだけに制限すれば、より効率的に格納できます。

```jldoctest
julia> a = Float64[]
Float64[]

julia> push!(a, 1); push!(a, 2.0); push!(a,  π)
3-element Vector{Float64}:
 1.0
 2.0
 3.141592653589793
```

これにより、`a`に数値を代入すると`Float64`に変換され、`a`は64ビット浮動小数点値の連続したブロックとして格納されるため、効率的に操作できます。

値の型が抽象型であるコンテナを避けられない場合は、実行時の型チェックを避けるため、`Any`を型パラメータにする方がよいこともあります。たとえば、`IdDict{Any, Any}`は`IdDict{Type, Vector}`よりも高性能です。

[Parametric Types](@ref)の説明も参照してください。

### Avoid fields with abstract type

型は、フィールドの型を指定せずに宣言できます。

```jldoctest myambig
julia> struct MyAmbiguousType
           a
       end
```

これにより、`a`は任意の型を取れます。これは便利なことも多いのですが、欠点もあります。`MyAmbiguousType`型のオブジェクトに対して、コンパイラは高性能なコードを生成できません。コンパイラはコードの生成方法を決める際に、オブジェクトの値ではなく型を使うためです。残念ながら、`MyAmbiguousType`型のオブジェクトについて推論できることはほとんどありません。

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

`b`と`c`の値は同じ型ですが、メモリ上でのデータ表現は大きく異なります。フィールド`a`に数値だけを格納していたとしても、[`UInt8`](@ref)と[`Float64`](@ref)ではメモリ表現が異なるため、CPUはそれぞれを異なる種類の命令で処理する必要があります。必要な情報が型から得られないので、この判断を実行時に行わなければなりません。これが性能低下につながります。

`a`の型を宣言すれば、改善できます。ここでは、`a`が複数の型のいずれかになり得る場合を考えます。この場合、自然な解決策は型パラメータを使うことです。たとえば、次のようにします。

```jldoctest myambig2
julia> mutable struct MyType{T<:AbstractFloat}
           a::T
       end
```

これは、次の定義よりもよい選択です。

```jldoctest myambig2
julia> mutable struct MyStillAmbiguousType
           a::AbstractFloat
       end
```

最初の定義では、ラッパーオブジェクトの型から`a`の型を特定できるためです。たとえば、次のようになります。

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

フィールド`a`の型は、`m`の型から容易に判定できますが、`t`の型からは判定できません。実際、`t`ではフィールド`a`の型を変更できます。

```jldoctest myambig2
julia> typeof(t.a)
Float64

julia> t.a = 4.5f0
4.5f0

julia> typeof(t.a)
Float32
```

これに対し、`m`を構築した後は、`m.a`の型を変更できません。

```jldoctest myambig2
julia> m.a = 4.5f0
4.5f0

julia> typeof(m.a)
Float64
```

`m.a`の型が`m`の型からわかり、さらに関数の実行途中でその型が変わることもないため、コンパイラは`m`のようなオブジェクトに対して高度に最適化されたコードを生成できます。一方、`t`のようなオブジェクトでは、それができません。

もちろん、これらが成り立つのは、`m`を具象型で構築した場合だけです。抽象型を明示的に指定して構築すると、この性質は失われます。

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

実用上、このようなオブジェクトの振る舞いは`MyStillAmbiguousType`のオブジェクトと同じです。

次の単純な関数について、

```julia
func(m::MyType) = m.a+1
```

次を使って生成されるコードの量を比較すると、非常に参考になります。

```julia
code_llvm(func, Tuple{MyType{Float64}})
code_llvm(func, Tuple{MyType{AbstractFloat}})
```

長くなるため結果はここには示しませんが、ぜひ自分で試してみてください。最初のケースでは型が完全に指定されているため、コンパイラは実行時に型を判定するコードを生成する必要がありません。その結果、コードは短く、高速になります。

型パラメータが完全には指定されていない型は、抽象型のように振る舞うことにも注意してください。たとえば、完全に指定された`Array{T,n}`は具象型ですが、パラメータを指定しない`Array`自体は具象型ではありません。

```jldoctest myambig3
julia> !isconcretetype(Array), !isabstracttype(Array), isstructtype(Array), !isconcretetype(Array{Int}), isconcretetype(Array{Int,1})
(true, true, true, true, true)
```

この場合、`MyType`をフィールド`a::Array`付きで宣言することは避け、代わりにフィールドを`a::Array{T,N}`または`a::A`として宣言する方がよいでしょう。ここで、`{T,N}`または`A`は`MyType`のパラメータです。

この助言は、構造体のフィールドに関数、あるいはより一般的な呼び出し可能オブジェクトを格納する場合に特に役立ちます。次のような構造体を定義したくなるかもしれません。

```julia
struct MyCallableWrapper
    f::Function
end
```

しかし、`Function`は抽象型なので、フィールド`f`へのアクセスが型不安定になり、`wrapper.f`を呼び出すたびに動的ディスパッチが必要になります。代わりに、次のように書いてください。

```julia
struct MyCallableWrapper{F}
    f::F
end
```

振る舞いはほぼ同じですが、型の不安定性がなくなるため、はるかに高速になります。ここで`F<:Function`という制約を課していないことに注意してください。つまり、`Function`のサブタイプではない呼び出し可能オブジェクトも、フィールド`f`に格納できます。

### Avoid fields with abstract containers

同じベストプラクティスは、コンテナ型にも適用できます。

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

たとえば、次のようになります。

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

`MySimpleContainer`では、型とパラメータによってオブジェクトが完全に指定されるため、コンパイラは最適化された関数を生成できます。たいていの場合、これで十分でしょう。

これでコンパイラは十分に役割を果たせますが、*コードを書く側*としては、`a`の*要素型*に応じて異なる処理を行いたい場合もあります。通常、そのための最善の方法は、対象の処理（ここでは`foo`）を別の関数にまとめることです。

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

こうすると、コードを単純に保ちながら、コンパイラがすべてのケースで最適化されたコードを生成できます。

ただし、`MySimpleContainer`のフィールド`a`について、要素型や`AbstractVector`の型に応じて、外側の関数の異なるバージョンを宣言する必要がある場合もあります。その場合は、次のように書けます。

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

任意の型の値を格納できるデータ構造（`Array{Any}`型の配列）は、便利なことがよくあります。ただし、このような構造を使っていて、ある要素の型がわかっている場合は、その情報をコンパイラに伝えると役立ちます。

```julia
function foo(a::Array{Any,1})
    x = a[1]::Int32
    b = x+1
    ...
end
```

ここでは、`a`の最初の要素が[`Int32`](@ref)になることがわかっていました。このような注釈には、値が期待した型でなければ実行時エラーが発生するという利点もあり、一部のバグを早期に検出できる可能性があります。

`a[1]`の型が正確にはわからない場合、`x = convert(Int32, a[1])::Int32`によって`x`を宣言できます。[`convert`](@ref)関数を使うと、`a[1]`は`Int32`に変換可能な任意のオブジェクト（`UInt8`など）にできます。これにより、型の要件を緩めてコードの汎用性を高められます。なお、この文脈で型安定性を実現するには、`convert`自体にも型注釈が必要です。コンパイラは、関数のすべての引数の型がわからなければ、`convert`であっても、その戻り値の型を推論できないためです。

型が抽象型である場合や、実行時に構築される場合、型注釈は性能を向上させず、むしろ低下させることがあります。コンパイラがその注釈を使って後続のコードを特殊化できず、型チェック自体にも時間がかかるためです。たとえば、次のコードでは、

```julia
function nr(a, prec)
    ctype = prec == 32 ? Float32 : Float64
    b = Complex{ctype}(a)
    c = (b + 1.0f0)::Complex{ctype}
    abs(c)
end
```

`c`の注釈が性能を低下させます。実行時に構築される型を使って高性能なコードを書くには、後述の[function-barrier technique](@ref kernel-functions)を利用し、構築した型がカーネル関数の引数の型に含まれるようにしてください。これにより、コンパイラはカーネル内の処理を適切に特殊化できます。たとえば、上のコードでは、`b`を構築した直後に、カーネルとなる別の関数`k`へ渡せます。仮に関数`k`で、`b`を`Complex{T}`型の引数として宣言し、`T`が型パラメータであれば、`k`内の代入文にある次の形式の型注釈は、

```julia
c = (b + 1.0f0)::Complex{T}
```

性能を低下させません（ただし向上もさせません）。`k`のコンパイル時に、コンパイラが`c`の型を判定できるためです。

### Be aware of when Julia avoids specializing

Juliaはヒューリスティックとして、`Type`、`Function`、`Vararg`という3つの特定のケースでは、引数の型パラメータに基づく自動的な[specializing](@ref man-method-specializations)を避けます。引数がメソッド内で使われる場合は常に特殊化しますが、単に別の関数に渡されるだけの場合は特殊化しません。通常、これは実行時の性能に影響せず、[improves compiler performance](@ref compiler-efficiency-issues)。実際のコードで実行時の性能に影響があるとわかった場合は、メソッド宣言に型パラメータを追加すると特殊化を促せます。以下に例を示します。

これは特殊化されません。

```julia
function f_type(t)  # or t::Type
    x = ones(t, 10)
    return sum(map(sin, x))
end
```

一方、これは特殊化されます。

```julia
function g_type(t::Type{T}) where T
    x = ones(T, 10)
    return sum(map(sin, x))
end
```

これらは特殊化されません。

```julia
f_func(f, num) = ntuple(f, div(num, 2))
g_func(g::Function, num) = ntuple(g, div(num, 2))
```

一方、これは特殊化されます。

```julia
h_func(h::H, num) where {H} = ntuple(h, div(num, 2))
```

これは特殊化されません。

```julia
f_vararg(x::Int...) = tuple(x...)
```

一方、これは特殊化されます。

```julia
g_vararg(x::Vararg{Int, N}) where {N} = tuple(x...)
```

ほかの型に制約がなくても、型パラメータを1つ導入するだけで特殊化を強制できます。たとえば、次も特殊化され、引数の型がすべて同じではない場合に役立ちます。

```julia
h_vararg(x::Vararg{Any, N}) where {N} = tuple(x...)
```

[`@code_typed`](@ref)やその関連ツールは、Juliaが通常ならそのメソッド呼び出しを特殊化しない場合でも、常に特殊化されたコードを表示する点に注意してください。引数の型が変わったときに特殊化が生成されるかどうか、つまり`Base.specializations(@which f(...))`に対象の引数に対する特殊化が含まれているかを確認するには、[method internals](@ref ast-lowered-method)を調べる必要があります。

### Write "type-stable" functions

可能であれば、関数が常に同じ型の値を返すようにすると効果的です。次の定義を考えてみましょう。

```julia
pos(x) = x < 0 ? 0 : x
```

一見問題なさそうですが、`0`が整数（`Int`型）である一方、`x`は任意の型になり得るという問題があります。そのため、この関数は`x`の値に応じて、2種類の型のいずれかの値を返す可能性があります。この振る舞いは許されており、場合によっては望ましいこともあります。ただし、次のように簡単に修正できます。

```julia
pos(x) = x < 0 ? zero(x) : x
```

[`oneunit`](@ref)関数や、より汎用的な[`oftype(x, y)`](@ref)関数もあります。後者は、`y`を`x`の型に変換して返します。

### Avoid changing the type of a variable

関数内で繰り返し使う変数にも、同様の「型安定性」の問題があります。

```julia
function foo()
    x = 1
    for i = 1:10
        x /= rand()
    end
    return x
end
```

ローカル変数`x`は最初は整数ですが、ループを1回実行すると浮動小数点数になります（[`/`](@ref)演算子の結果です）。このため、コンパイラがループ本体を最適化しにくくなります。修正方法はいくつかあります。

  * `x`を`x = 1.0`で初期化する
  * `x`の型を`x::Float64 = 1`として明示的に宣言する
  * `x = oneunit(Float64)`による明示的な変換を使う
  * ループの最初の反復に相当する`x = 1 / rand()`で初期化してから、`for i = 2:10`のループを実行する

### [Separate kernel functions (aka, function barriers)](@id kernel-functions)

多くの関数は、何らかの準備処理を行った後、多数の反復によって中心となる計算を行うパターンに従っています。可能であれば、この中心となる計算を別の関数に分けるとよいでしょう。たとえば、次の説明用の関数は、無作為に選んだ型の配列を返します。

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

これは次のように書くべきです。

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

Juliaのコンパイラは、関数の境界で引数の型に応じてコードを特殊化します。そのため、元の実装では、ループ内での`a`の型がわかりません（無作為に選ばれるためです）。2つ目の実装では、`a`の型ごとに、内側のループを`fill_twos!`の一部として再コンパイルできるため、一般に高速になります。

2つ目の形式は、書き方としても優れていることが多く、コードの再利用にもつながります。

このパターンはJulia Baseの複数の箇所で使われています。たとえば、[`abstractarray.jl`](https://github.com/JuliaLang/julia/blob/40fe264f4ffaa29b749bcf42239a89abdcbba846/base/abstractarray.jl#L1205-L1206)の`vcat`と`hcat`を参照してください。また、独自の`fill_twos!`を書く代わりに使えた[`fill!`](@ref)関数も、この例に当たります。

`strange_twos`のような関数は、型が不確定なデータを扱う場合に現れます。たとえば、整数、浮動小数点数、文字列、あるいはその他のデータが含まれる可能性のある入力ファイルから読み込んだデータを扱う場合です。

### [[`@code_warntype`](@ref)](@id man-code-warntype)

[`@code_warntype`](@ref)マクロ（またはその関数版の[`code_warntype`](@ref)）は、型に関する問題の診断に役立つことがあります。次に例を示します。

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

[`@code_warntype`](@ref)の出力を読み解くには、関連する[`@code_lowered`](@ref)、[`@code_typed`](@ref)、[`@code_llvm`](@ref)、[`@code_native`](@ref)と同様、少し練習が必要です。コードは、コンパイル済み機械語コードの生成に至る過程で大幅に変換された形式で表示されます。ほとんどの式には型が注釈され、`::T`で示されます（`T`には、たとえば[`Float64`](@ref)が入ります）。[`@code_warntype`](@ref)の最も重要な特徴は、具象型でない型が赤色で表示されることです。この文書は色のないMarkdownで書かれているため、赤色のテキストを大文字で表しています。

先頭には、推論された関数の戻り値の型が`Body::Float64`として表示されます。続く行は、`f`の本体をJuliaのSSA IR形式で表しています。番号付きの枠はラベルであり、コード内のジャンプ（`goto`による）の行き先を示しています。本体を見ると、最初に`pos`が呼び出され、その戻り値が`Union`型の`Union{Float64, Int64}`と推論されていることがわかります。具象型ではないため、大文字で表示されています。つまり、入力の型から`pos`の正確な戻り値の型を知ることはできません。ただし、`y`が`Float64`でも`Int64`でも、`y*x`の結果は`Float64`です。そのため、中間の計算の一部が型不安定であっても、`f(x::Float64)`の出力は型不安定にはなりません。

この情報をどう活用するかは、あなた次第です。もちろん、`pos`を型安定になるよう修正するのが、圧倒的に最善です。そうすれば`f`内のすべての変数が具象型となり、性能も最適になります。ただし、このような*一時的な*型の不安定性がそれほど問題にならない状況もあります。たとえば、`pos`が単独では使われない場合、`f`の出力が（[`Float64`](@ref)の入力に対して）型安定であることにより、後続のコードへの型の不安定性の波及を防げます。これは、型の不安定性を修正することが難しい、あるいは不可能な場合に特に重要です。その場合、上記のヒント（型注釈の追加や関数の分割など）が、型の不安定性による「被害」を抑えるための最も有効な手段になります。また、Julia Baseにも型不安定な関数があることに注意してください。たとえば、[`findfirst`](@ref)関数は、キーが見つかった場合は配列内のインデックスを、見つからなかった場合は`nothing`を返すため、明らかに型不安定です。重要である可能性が高い型の不安定性を見つけやすくするため、`missing`または`nothing`を含む`Union`は、赤色ではなく黄色で強調表示されます。

以下の例は、具象型でない型を含むと示された式を読み解くのに役立つでしょう。

  * `Body::Union{T1,T2})`で始まる関数本体

      * 意味：戻り値の型が不安定な関数
      * 対策：必要なら型注釈を付けてでも、戻り値を型安定にする
  * `invoke Main.g(%%x::Int64)::Union{Float64, Int64}`

      * 意味：型不安定な関数`g`の呼び出し
      * 対策：関数を修正するか、必要に応じて戻り値に型注釈を付ける
  * `invoke Base.getindex(%%x::Array{Any,1}, 1::Int64)::Any`

      * 意味：型の指定が不十分な配列の要素へのアクセス
      * 対策：型がより明確に定義された配列を使うか、必要に応じて個々の要素アクセスに型注釈を付ける
  * `Base.getfield(%%x, :(:data))::Array{Float64,N} where N`

      * 意味：具象型でないフィールドの取得。この例では、`x`の型を仮に`ArrayContainer`とすると、それにフィールド`data::Array{T}`がありました。しかし、`Array`が具象型になるには、次元`N`も必要です。
      * 対策：`Array{T,3}`や`Array{T,N}`のような具象型を使う。後者では`N`を`ArrayContainer`のパラメータにする

### [Performance of captured variable](@id man-performance-captured)

内部関数を定義する、次の例を考えてみましょう。

```julia
function abmult(r::Int)
    if r < 0
        r = -r
    end
    f = x -> x * r
    return f
end
```

関数`abmult`は、引数に`r`の絶対値を掛ける関数`f`を返します。`f`に代入された内部関数は「クロージャ」と呼ばれます。言語の仕組みとして、内部関数は`do`ブロックやジェネレータ式にも使われます。

この書き方は、言語の実装にとって性能上の課題となります。パーサーはこれを低水準の命令に変換する際、内部関数を別のコードブロックに取り出すなど、上のコードを大きく再構成します。内部関数とそれを囲むスコープで共有される`r`のような「キャプチャされた」変数も、ヒープに割り当てられた「ボックス」に取り出され、内側と外側の両方の関数からアクセスできるようになります。これは、外側のスコープ（または別の内部関数）が`r`を変更した後でも、内側のスコープの`r`と外側のスコープの`r`が同一でなければならないと、言語仕様で定められているためです。

前の段落で述べた「パーサー」とは、`abmult`を含むモジュールが最初に読み込まれるときに行われるコンパイル段階を指します。これは、後に初めて呼び出されるときの段階とは異なります。パーサーは、`Int`の型が固定されていることも、文`r = -r`が`Int`を別の`Int`に変換することも「知りません」。型推論の力が発揮されるのは、後のコンパイル段階です。

したがって、パーサーには`r`が固定の型（`Int`）を持つことがわかりません。また、内部関数の作成後に`r`の値が変わらないこと（したがってボックスが不要であること）もわかりません。そのため、パーサーは`Any`のような抽象型のオブジェクトを保持するボックス用のコードを生成し、`r`を使うたびに実行時の型ディスパッチが必要になります。これは、上の関数に`@code_warntype`を適用すると確認できます。ボックス化と実行時の型ディスパッチは、どちらも性能低下を招く可能性があります。

性能が重要なコードでキャプチャされた変数を使う場合は、次のヒントが高速な実行に役立ちます。まず、キャプチャされた変数の型が変わらないとわかっている場合は、型注釈によって明示的に宣言できます（右辺ではなく、変数に注釈を付けます）。

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

型注釈により、パーサーがボックス内のオブジェクトに具象型を関連付けられるため、キャプチャによって失われた性能が部分的に回復します。さらに、キャプチャされた変数をそもそもボックス化する必要がない場合（クロージャの作成後に再代入されないため）は、次のように`let`ブロックでそのことを示せます。

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

`let`ブロックは、内部関数だけをスコープとする新しい変数`r`を作成します。この2つ目の手法を使うと、キャプチャされた変数があっても本来の性能を完全に取り戻せます。なお、コンパイラのこの部分は急速に進化しており、将来のリリースでは、性能を得るためにプログラマがここまで注釈を付ける必要はなくなる可能性があります。それまでの間は、[FastClosures](https://github.com/c42f/FastClosures.jl)のようなコミュニティ製パッケージを使うと、`abmult3`のような`let`文の挿入を自動化できます。

#### Use `@__FUNCTION__` for recursive closures

特に再帰的なクロージャでは、[`@__FUNCTION__`](@ref)マクロによって、型の不安定性とボックス化の両方を避けられます。

まず、最適化前のコードを見てみましょう。

```julia
function make_fib_unoptimized()
    fib(n) = n <= 1 ? 1 : fib(n - 1) + fib(n - 2)  # fib is boxed
    return fib
end
```

`fib`関数はボックス化されるため、戻り値の型は`Any`と推論されます。

```julia
@code_warntype make_fib_unoptimized()
```

この型の不安定性をなくすには、代わりに`@__FUNCTION__`を使って具象型の関数オブジェクトを参照します。

```julia
function make_fib_optimized()
    fib(n) = n <= 1 ? 1 : (@__FUNCTION__)(n - 1) + (@__FUNCTION__)(n - 2)
    return fib
end
```

これで戻り値の型が具象型になります。

```julia
@code_warntype make_fib_optimized()
```

### [Types with values-as-parameters](@id man-performance-value-type)

各軸のサイズが3の`N`次元配列を作りたいとします。このような配列は次のように作成できます。

```jldoctest
julia> A = fill(5.0, (3, 3))
3×3 Matrix{Float64}:
 5.0  5.0  5.0
 5.0  5.0  5.0
 5.0  5.0  5.0
```

この方法は非常にうまく機能します。コンパイラは、埋める値の型（`5.0::Float64`）と次元数（`(3, 3)::NTuple{2,Int}`）を把握しているため、`A`が`Array{Float64,2}`であると判断できます。そのため、同じ関数内でその後に`A`を使うあらゆる処理について、非常に効率的なコードを生成できます。

では、任意の次元数の3×3×…配列を作成する関数を書きたい場合はどうでしょうか。次のような関数を書きたくなるかもしれません。

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

これは動作しますが、出力の型を推論できないという問題があります（`@code_warntype array3(5.0, 2)`を使えば自分で確認できます）。引数`N`は`Int`型の*値*であり、型推論はその値を事前に予測しませんし、予測することもできません。このため、この関数の出力を使うコードは保守的に処理する必要があり、`A`にアクセスするたびに型を確認するので、非常に遅くなります。

このような問題を解決する非常によい方法の1つが、[function-barrier technique](@ref kernel-functions)の利用です。ただし、型の不安定性を完全になくしたい場合もあります。その場合の方法の1つは、たとえば`Val{T}()`を介して、次元数を型パラメータとして渡すことです（["Value types"](@ref)を参照）。

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

Juliaには、2番目のパラメータとして`Val{::Int}`のインスタンスを受け取る、`ntuple`の特殊なバージョンがあります。`N`を型パラメータとして渡すことで、その「値」をコンパイラに知らせられます。その結果、このバージョンの`array3`では、コンパイラが戻り値の型を予測できます。

ただし、こうした手法の利用には、意外に繊細な注意が必要です。たとえば、次のような関数から`array3`を呼び出しても、効果はありません。

```julia
function call_array3(fillval, n)
    A = array3(fillval, Val(n))
end
```

ここでは、同じ問題を再び作り出しています。コンパイラは`n`の値を予測できないので、`Val(n)`の*型*もわかりません。`Val`を誤って使うと、多くの状況で簡単に性能が*悪化*します。（上のようなコードを使うべきなのは、`Val`と関数バリアの手法を効果的に組み合わせて、カーネル関数を効率化する場合だけです。）

`Val`の正しい使用例は、次のようになります。

```julia
function filter3(A::AbstractArray{T,N}) where {T,N}
    kernel = array3(1, Val(N))
    filter(A, kernel)
end
```

この例では、`N`が型パラメータとして渡されるため、その「値」をコンパイラが把握しています。基本的に、`Val(T)`が有効なのは、`T`がハードコードされた値・リテラル（`Val(3)`）であるか、すでに型の領域で指定されている場合だけです。

### The dangers of abusing multiple dispatch (aka, more on types with values-as-parameters)

多重ディスパッチのよさがわかると、何にでも使おうとして、ついやり過ぎてしまいがちです。たとえば、情報を格納するために次のように使い、

```
struct Car{Make, Model}
    year::Int
    ...more fields...
end
```

`Car{:Honda,:Accord}(year, args...)`のようなオブジェクトに対してディスパッチすることを考えるかもしれません。

これは、次のいずれかが成り立つ場合には有用かもしれません。

  * 各`Car`に対してCPU負荷の高い処理が必要であり、`Make`と`Model`がコンパイル時にわかると大幅に効率化でき、かつ、使用する`Make`または`Model`の種類の総数がそれほど多くない。
  * 同じ型の`Car`からなる均一なリストを処理するため、すべてを`Array{Car{:Honda,:Accord},N}`に格納できる。

後者が成り立つ場合、このような均一な配列を処理する関数は、効果的に特殊化できます。Juliaは各要素の型を事前に把握しています（コンテナ内のすべてのオブジェクトが同じ具象型を持つためです）。そのため、関数のコンパイル時に正しいメソッド呼び出しを「検索」でき、実行時のチェックが不要になり、リスト全体を処理する効率的なコードを生成できます。

これらの条件が成り立たない場合は、おそらく利点が得られず、それどころか「型の組合せ爆発」が逆効果になります。`items[i+1]`と`item[i]`の型が異なると、Juliaは実行時に型を調べ、メソッドテーブルで適切なメソッドを探し、型の共通部分の計算によって一致するものを判断し、JITコンパイル済みかを確認し（未コンパイルならコンパイルし）、その後で呼び出す必要があります。つまり、自分のコード内でswitch文や辞書検索に相当する処理を行うためだけに、型システムとJITコンパイルの仕組み全体を動かしていることになります。

（1）型ディスパッチ、（2）辞書検索、（3）「switch」文の実行時間を比較したベンチマークは、[on discourse](https://discourse.julialang.org/t/suggestion-updating-the-dispatch-vs-dict-switch-benchmark-link-in-the-manual/132159)で確認できます。

実行時への影響以上に深刻かもしれないのが、コンパイル時への影響です。Juliaは異なる`Car{Make, Model}`ごとに特殊化された関数をコンパイルします。このような型が数百、数千とあると、そのオブジェクトを引数として受け取るすべての関数について、数百、数千のバリエーションがコンパイルされます。これは、自分で書く独自の`get_year`関数から、Julia Baseの汎用的な`push!`関数まで及びます。その1つ1つが、コンパイル済みコードのキャッシュサイズや内部のメソッドリストの長さなどを増大させます。値を型パラメータとして使うことに熱中し過ぎると、膨大なリソースを簡単に浪費してしまいます。

## Memory management and arrays

### Pre-allocate outputs

関数が`Array`やその他の複雑な型を返す場合、メモリを割り当てる必要があるかもしれません。残念ながら、メモリ割り当てと、その逆の処理に当たるガベージコレクションは、しばしば大きなボトルネックになります。

出力用の領域を事前に割り当てることで、関数呼び出しのたびにメモリを割り当てずに済む場合があります。単純な例として、次のコードと、

```jldoctest prealloc
julia> function xinc(x)
           return [x + i for i  in 1:3000]
       end;

julia> function loopinc()
           y = 0
           for i = 1:10^5
               ret = xinc(i)
               y += ret[2]
           end
           return y
       end;
```

次のコードを比較してください。

```jldoctest prealloc
julia> function xinc!(ret::AbstractVector{T}, x::T) where T
           for i in 1:3000
               ret[i] = x+i
           end
           nothing
       end;

julia> function loopinc_prealloc()
           ret = Vector{Int}(undef, 3000)
           y = 0
           for i = 1:10^5
               xinc!(ret, i)
               y += ret[2]
           end
           return y
       end;
```

時間測定の結果は次のとおりです。

```jldoctest prealloc; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> @time loopinc()
  0.297454 seconds (200.00 k allocations: 2.239 GiB, 39.80% gc time)
5000250000

julia> @time loopinc_prealloc()
  0.009410 seconds (2 allocations: 23.477 KiB)
5000250000
```

事前割り当てには、ほかにも利点があります。たとえば、呼び出し側がアルゴリズムの「出力」の型を制御できます。上の例では、必要なら[`Array`](@ref)ではなく`SubArray`を渡すこともできました。

事前割り当てを徹底し過ぎるとコードが読みにくくなることがあるため、性能測定と適切な判断が必要になるでしょう。ただし、「ベクトル化された」（要素ごとの）関数では、便利な構文`x .= f.(y)`を使うことで、ループを融合し、一時配列を作成せずにインプレース操作を行えます（[dot syntax for vectorizing functions](@ref man-vectorized)を参照）。

### [Consider using views for slices](@id man-performance-views)

Juliaでは、`array[1:5, :]`のような配列の「スライス」式は、そのデータのコピーを作成します。ただし、代入の左辺は例外で、`array[1:5, :] = ...`は`array`の該当部分にインプレースで代入します。スライスに対して多くの操作を行う場合は、小さく連続したコピーを扱う方が元の配列にインデックスでアクセスするより効率的なので、コピーが性能面で有利になることがあります。一方、スライスに対して単純な操作を少し行うだけなら、割り当てとコピーのコストが大きくなる可能性があります。

別の方法は、配列の「ビュー」を作成することです。これは、コピーを作らず、元の配列のデータをその場で参照する配列オブジェクト（`SubArray`）です。（ビューへの書き込みは、元の配列のデータも変更します。）個々のスライスでは[`view`](@ref)を呼び出して作成できます。また、式やコードブロック全体に適用する場合は、その前に[`@views`](@ref)を置く方が簡単です。たとえば、次のようにします。

```jldoctest; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> fcopy(x) = sum(x[2:end-1]);

julia> @views fview(x) = sum(x[2:end-1]);

julia> x = rand(10^6);

julia> @time fcopy(x);
  0.003051 seconds (3 allocations: 7.629 MB)

julia> @time fview(x);
  0.001020 seconds (1 allocation: 16 bytes)
```

`fview`を使った関数では、速度が3倍になり、メモリ割り当ても減少していることに注目してください。

### Consider StaticArrays.jl for small fixed-size vector/matrix operations

固定サイズ（実行前にサイズがわかっている）の小さな配列（`< 100`要素）を多数扱うアプリケーションでは、[StaticArrays.jl package](https://github.com/JuliaArrays/StaticArrays.jl)の利用を検討するとよいでしょう。このパッケージでは、不要なヒープ割り当てを避け、コンパイラが配列の*サイズ*に応じてコードを特殊化できる形で、配列を表現できます。たとえば、ベクトル演算を完全に展開してループをなくしたり、要素をCPUレジスタに格納したりできます。

たとえば、2次元の幾何計算を行う場合、2成分ベクトルの計算が多数必要になるかもしれません。StaticArrays.jlの`SVector`型を使うと、便利なベクトル表記を利用し、ベクトル`v`と`w`に対して`norm(3v - w)`のような操作を記述できます。同時に、コンパイラはそのコードを、`@inbounds hypot(3v[1]-w[1], 3v[2]-w[2])`と同等の最小限の計算に展開できます。

### More dots: Fuse vectorized operations

Juliaには特別な[dot syntax](@ref man-vectorized)があり、任意のスカラー関数を「ベクトル化された」関数呼び出しに、任意の演算子を「ベクトル化された」演算子に変換できます。入れ子になった「ドット呼び出し」は*融合する*という特性を持ち、一時配列を割り当てずに、構文レベルで単一のループにまとめられます。`.=`などの代入演算子を使うと、事前に割り当てた配列に結果をインプレースで格納することもできます（前述）。

線形代数の文脈では、`vector + vector`や`vector * scalar`のような演算が定義されていても、代わりに`vector .+ vector`や`vector .* scalar`を使う方が有利な場合があります。生成されるループを、周囲の計算と融合できるためです。たとえば、次の2つの関数を考えてみましょう。

```jldoctest dotfuse
julia> f(x) = 3x.^2 + 4x + 7x.^3;

julia> fdot(x) = @. 3x^2 + 4x + 7x^3; # equivalent to 3 .* x.^2 .+ 4 .* x .+ 7 .* x.^3
```

`f`と`fdot`は、どちらも同じ計算を行います。ただし、[`@.`](@ref @__dot__)マクロを使って定義した`fdot`は、配列に適用すると大幅に高速になります。

```jldoctest dotfuse; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> x = rand(10^6);

julia> @time f(x);
  0.019049 seconds (16 allocations: 45.777 MiB, 18.59% gc time)

julia> @time fdot(x);
  0.002790 seconds (6 allocations: 7.630 MiB)

julia> @time f.(x);
  0.002626 seconds (8 allocations: 7.630 MiB)
```

つまり、`fdot(x)`は`f(x)`の10倍高速で、メモリ割り当ては6分の1です。`f(x)`では、各`*`演算と`+`演算が新しい一時配列を割り当て、それぞれ別のループで実行されるためです。この例では`f.(x)`は`fdot(x)`と同じ速さですが、多くの場合、ベクトル化する操作ごとに別の関数を定義するよりも、式にドットをいくつか加える方が便利です。

### [Fewer dots: Unfuse certain intermediate broadcasts](@id man-performance-unfuse)

前述のドットによるループ融合を使うと、簡潔でJuliaらしいコードで高性能な操作を表現できます。ただし、融合された処理はブロードキャストの各反復で計算されることを忘れないでください。そのため、特に複合的なブロードキャストや多次元ブロードキャストでは、ドット呼び出しを含む式が、意図した回数より多く関数を計算している場合があります。例として、各行のユークリッドノルムが1であるランダムな行列を作りたいとします。次のように書くかもしれません。

```
julia> x = rand(1000, 1000);

julia> d = sum(abs2, x; dims=2);

julia> @time x ./= sqrt.(d);
  0.002049 seconds (4 allocations: 96 bytes)
```

これは動作します。しかし実際には、行`x[i, :]`の*各要素*について`sqrt(d[i])`を再計算するため、必要以上に多くの平方根が計算されます。ブロードキャストがどのインデックスを反復するのか正確に知るには、融合された式の引数に対して`Broadcast.combine_axes`を呼び出します。これは、各要素が反復の軸に対応する範囲のタプルを返します。これらの範囲の長さの積が、融合された処理の総呼び出し回数になります。

したがって、ブロードキャスト式の一部がある軸に沿って一定である場合は、その部分を強制的に「融合解除」することで、性能が向上する可能性があります。前の例では、第2次元に沿った`sqrt`がこれに当たります。つまり、そのブロードキャスト演算の結果用の領域を事前に割り当て、値が一定となる軸に沿ってキャッシュ済みの値を再利用します。具体的には、一時変数を使う、ドット式の一部を`identity`で包む、同等の処理を行う元からベクトル化された（ただし融合されない）関数を使う、といった方法があります。

```
julia> @time let s = sqrt.(d); x ./= s end;
  0.000809 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= identity(sqrt.(d));
  0.000608 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= map(sqrt, d);
  0.000611 seconds (4 allocations: 8.016 KiB)
```

いずれの方法でも、割り当てが1回増える代わりに、およそ3倍の高速化が得られます。ブロードキャスト対象が大きい場合、この高速化の効果は漸近的に非常に大きくなり得ます。

### [Access arrays in memory order, along columns](@id man-performance-column-major)

Juliaの多次元配列は、列優先順序で格納されます。つまり、列を1列ずつ順に並べて格納します。これは、以下のように`vec`関数または`[:]`構文を使うと確認できます（配列の順序が`[1 2 3 4]`ではなく`[1 3 2 4]`であることに注目してください）。

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

この配列の格納順序は、Fortran、Matlab、Rなど、多くの言語で一般的です。列優先順序のもう一方の選択肢が行優先順序で、CやPython（`numpy`）などが採用しています。配列の格納順序を意識することは、配列をループで走査する際の性能に大きく影響します。覚えておくとよい目安は、列優先の配列では最初のインデックスが最も速く変化するということです。つまり、最も内側のループのインデックスが、スライス式の最初のインデックスであれば、ループが高速になります。また、配列を`:`でインデックス指定する操作は、ある次元の全要素に順にアクセスする暗黙のループであることにも注意してください。たとえば、行を取り出すより列を取り出す方が速い場合があります。

次の説明用の例を考えてみましょう。[`Vector`](@ref)を受け取り、各行または各列を入力ベクトルのコピーで埋めた正方形の[`Matrix`](@ref)を返す関数を書きたいとします。コピーで埋めるのが行か列かは重要でないものとします（たとえば、残りのコードをそれに合わせて簡単に変更できる場合です）。推奨される組み込みの[`repeat`](@ref)の呼び出し以外にも、少なくとも次の4つの方法が考えられます。

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

同じランダムな`10000`×`1`の入力ベクトルを使い、各関数の時間を測定します。

```julia-repl
julia> x = randn(10000);

julia> fmt(f) = println(rpad(string(f)*": ", 14, ' '), @elapsed f(x))

julia> map(fmt, [copy_cols, copy_rows, copy_col_row, copy_row_col]);
copy_cols:    0.331706323
copy_rows:    1.799009911
copy_col_row: 0.415630047
copy_row_col: 1.721531501
```

`copy_cols`が`copy_rows`より大幅に高速であることに注目してください。これは予想どおりです。`copy_cols`は、`Matrix`の列優先のメモリ配置に従い、1列ずつ埋めるためです。また、`copy_col_row`が`copy_row_col`より大幅に高速なのは、スライス式の最初のインデックスを最も内側のループに対応させる、という目安に従っているためです。

### Copying data is not always bad

配列はメモリ上に連続して格納されるため、CPUによるベクトル化や、キャッシュによるメモリアクセスの削減に適しています。これらは、配列に列優先順序でアクセスすることを推奨する理由でもあります（前述）。不規則なアクセスパターンや非連続なビューでは、メモリアクセスが非連続になるため、配列の計算速度が大幅に低下する可能性があります。

不規則にアクセスされるデータを、繰り返しアクセスする前に連続した配列へコピーすると、以下の例のように大幅に高速化できることがあります。ここでは、無作為に並べ替えたインデックスで行列にアクセスしてから、乗算を行っています。通常の配列にコピーすると、コピーと割り当てのコストを加味しても、乗算が高速になります。

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

十分なメモリがあれば、連続した配列で行列乗算を繰り返すことによる高速化の効果が、ビューを配列にコピーするコストを上回ります。

### [Multithreading and linear algebra](@id man-multithreading-linear-algebra)

この節は、各スレッドで線形代数演算を行う、マルチスレッドのJuliaコードを対象としています。これらの線形代数演算ではBLAS / LAPACKが呼び出され、それ自体もマルチスレッドで動作します。この場合、2種類のマルチスレッド処理によって、コアが過剰に使われないようにする必要があります。

Juliaは線形代数用に独自のOpenBLASをコンパイルして使用しており、そのスレッド数は環境変数`OPENBLAS_NUM_THREADS`で制御されます。Juliaの起動時にコマンドラインで設定するか、Juliaのセッション中に`BLAS.set_num_threads(N)`で変更できます（サブモジュール`BLAS`は`using LinearAlgebra`からエクスポートされます）。現在の値は`BLAS.get_num_threads()`で取得できます。

ユーザーが何も指定しない場合、JuliaはプラットフォームやJuliaのバージョンなどに基づいて、適切なOpenBLASのスレッド数を選ぼうとします。ただし、一般には、値を確認して手動で設定することを推奨します。OpenBLASの動作は次のとおりです。

  * `OPENBLAS_NUM_THREADS=1`の場合、OpenBLASは呼び出し元のJuliaスレッドを使います。つまり、計算を実行するJuliaスレッドの「中で」動作します。
  * `OPENBLAS_NUM_THREADS=N>1`の場合、OpenBLASは独自のスレッドプール（合計`N`本）を作成して管理します。OpenBLASのスレッドプールは1つだけで、すべてのJuliaスレッド間で共有されます。

`JULIA_NUM_THREADS=X`でJuliaをマルチスレッドモードで起動する場合、一般には`OPENBLAS_NUM_THREADS=1`と設定することを推奨します。上記の動作から、BLASのスレッド数を`N>1`に増やすと、特に`N<<X`の場合、簡単に性能が悪化します。ただし、これはあくまで目安です。それぞれのスレッド数を最適に設定するには、実際のアプリケーションで試すのが最善です。

### [Alternative linear algebra backends](@id man-backends-linear-algebra)

OpenBLASの代わりに、線形代数の性能向上に役立つほかのバックエンドもいくつかあります。代表的な例は、[MKL.jl](https://github.com/JuliaLinearAlgebra/MKL.jl)と[AppleAccelerate.jl](https://github.com/JuliaMath/AppleAccelerate.jl)です。

これらは外部パッケージなので、ここでは詳しく説明しません。それぞれのドキュメントを参照してください（特に、マルチスレッドに関する動作がOpenBLASとは異なる点に注意してください）。

## Execution latency, package loading and package precompiling time

### Reducing time to first plot etc.

Juliaのメソッドが初めて呼び出されると、そのメソッドと、そこから呼び出されるメソッド、または静的に特定できるメソッドがコンパイルされます。[`@time`](@ref)の一連のマクロで、この様子を確認できます。

```
julia> foo() = rand(2,2) * rand(2,2)
foo (generic function with 1 method)

julia> @time @eval foo();
  0.252395 seconds (1.12 M allocations: 56.178 MiB, 2.93% gc time, 98.12% compilation time)

julia> @time @eval foo();
  0.000156 seconds (63 allocations: 2.453 KiB)
```

コンパイル時間の測定には、`@time @eval`の方が適していることに注意してください。[`@eval`](@ref)を使わないと、時間測定が始まる前に一部のコンパイルが済んでいる可能性があるためです。

パッケージを開発する際には、*事前コンパイル*によって、ユーザーが使うコードをあらかじめコンパイルしておき、利用体験を改善できる場合があります。パッケージのコードを効果的に事前コンパイルするには、[`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/)を使って、典型的なパッケージの利用方法を代表する「事前コンパイル用ワークロード」を事前コンパイル時に実行することを推奨します。これにより、コンパイル済みのネイティブコードがパッケージの`pkgimage`キャッシュに保存され、そのような利用での「初回実行までの時間」（一般にTTFXと呼ばれます）が大幅に短縮されます。

パッケージの開発中など、事前コンパイルに余分な時間をかけたくない場合は、[`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/)のワークロードを無効にでき、Preferencesを通じて設定できる場合もあることに注意してください。

### Reducing package loading time

パッケージの読み込み時間は、短く抑えるとたいてい有益です。パッケージ開発者向けの一般的な推奨事項は次のとおりです。

1. 依存関係を本当に必要なものだけに減らしてください。必須の依存関係を肥大化させずにほかのパッケージとの相互運用性を実現するため、[package extensions](@ref man-extensions)の利用を検討してください。
2. ほかに方法がない場合を除き、[`__init__()`](@ref)関数の使用を避けてください。特に、多量のコンパイルを引き起こす可能性があるものや、単に実行時間が長いものには注意してください。
3. 可能な限り、依存パッケージ間や自分のパッケージのコードによる[invalidations](https://julialang.org/blog/2020/08/invalidations/)を修正してください。

REPLで上記の要因を確認するには、[`@time_imports`](@ref)ツールが役立ちます。

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

この例では、複数のパッケージが読み込まれていることに注目してください。その一部には`__init__()`関数があり、その一部がコンパイルを引き起こし、さらにその一部は再コンパイルになっています。再コンパイルは、先に読み込まれたパッケージがメソッドを無効化したことによって発生します。このような場合、後続のパッケージが`__init__()`関数を実行すると、コードを実行する前に再コンパイルが必要になることがあります。

さらに、`SparseArrays`が依存関係ツリーに含まれるため、`Statistics`の拡張`SparseArraysExt`が有効になっていることにも注目してください。`0.4 ms  Statistics → SparseArraysExt`を参照してください。

このレポートは、依存パッケージの読み込み時間のコストが、得られる機能に見合うかを見直すよい機会になります。また、`Pkg`のユーティリティ`why`を使うと、間接的な依存関係が存在する理由を確認できます。

```
(CustomPackage) pkg> why FFMPEG_jll
  Plots → FFMPEG → FFMPEG_jll
  Plots → GR → GR_jll → FFMPEG_jll
```

また、あるパッケージが導入する間接的な依存関係を確認するには、そのパッケージを`pkg> rm`し、マニフェストから削除される依存関係を確認してから、`pkg> undo`で変更を元に戻すこともできます。

コンパイルを伴う遅い`__init__()`メソッドが読み込み時間の大半を占める場合、何がコンパイルされているかを詳しく調べる方法として、Juliaの引数`--trace-compile=stderr --trace-compile-timing`があります。これを使うと、メソッドがコンパイルされるたびに、[`precompile`](@ref)文と、コンパイルにかかった時間が報告されます。InteractiveUtilsのマクロ[`@trace_compile`](@ref)を使うと、特定の呼び出しに対してこれらの引数を有効にできます。完全なレポートを得る呼び出しは、次のようになります。

```
julia> @time @time_imports @trace_compile using CustomPackage
...
```

`--startup-file=no`に注目してください。これにより、`startup.jl`に含まれている可能性のあるパッケージから、テストを切り離せます。

再コンパイルの原因をさらに分析するには、[`SnoopCompile`](https://github.com/timholy/SnoopCompile.jl)パッケージを利用できます。

### Tracing expression evaluation

テストやスクリプトの実行中に、どのコードが評価されているかを把握する必要がある場合は、`--trace-eval`コマンドラインオプション、または[`Base.TRACE_EVAL`](@ref)によるグローバルな制御を使って、評価される最外側の式（トップレベルの文）をトレースできます。ただし、関数呼び出しやコードブロックの内部が個別に報告されるわけではありません。

```bash
# Show only location information during evaluation
julia --trace-eval=loc script.jl

# Show full expressions being evaluated
julia --trace-eval=full script.jl
```

プログラムから制御することもできます。

```julia
# Enable full expression tracing
Base.TRACE_EVAL = :full

# Show only locations
Base.TRACE_EVAL = :loc

# Disable tracing
Base.TRACE_EVAL = :no

# Reset to use command-line setting
Base.TRACE_EVAL = nothing
```

### Reducing precompilation time

パッケージの事前コンパイルに長い時間がかかる場合、次の内部設定を行ってから事前コンパイルする方法があります。

```
julia> Base.PRECOMPILE_TRACE_COMPILE[] = "stderr"

pkg> precompile
```

これにより、事前コンパイルのプロセス自体で`--trace-compile=stderr --trace-compile-timing`が設定され、どのメソッドが事前コンパイルされ、どれだけ時間がかかったかが表示されます。

[using the external profiler Tracy to profile the precompilation process](@ref Profiling-package-precompilation-with-Tracy)などのプロファイリング手段もあります。

## Miscellaneous

### Tweaks

以下は、処理の密な内部ループで役立つ可能性のある細かな注意点です。

  * 不要な配列を避けてください。たとえば、[`sum([x,y,z])`](@ref)の代わりに`x+y+z`を使ってください。
  * 複素数`z`には、[`abs(z)^2`](@ref)の代わりに[`abs2(z)`](@ref)を使ってください。一般に、引数が複素数の場合は、[`abs`](@ref)ではなく[`abs2`](@ref)を使うようにコードを書き換えてみてください。
  * 整数の切り捨て除算には[`trunc(x/y)`](@ref)の代わりに[`div(x,y)`](@ref)を、[`floor(x/y)`](@ref)の代わりに[`fld(x,y)`](@ref)を、[`ceil(x/y)`](@ref)の代わりに[`cld(x,y)`](@ref)を使ってください。

### Fix deprecation warnings

非推奨の関数は、対応する警告を一度だけ表示するために、内部で検索処理を行います。この追加の検索によって大幅に遅くなる可能性があるため、非推奨の関数を使っている箇所はすべて、警告の指示に従って修正してください。

### [Performance Annotations](@id man-performance-annotations)

プログラムの特定の性質を保証することで、よりよい最適化が可能になる場合があります。

  * [`@inbounds`](@ref)を使うと、式内の配列の境界チェックを省略できます。使用前に、安全であることを必ず確認してください。インデックスが一度でも範囲外になると、クラッシュや、気付かないままデータが破損する事態を招く可能性があります。
  * [`@fastmath`](@ref)を使うと、実数では正しいものの、IEEE浮動小数点数では結果に違いが生じる最適化を許可できます。数値計算の結果が変わる可能性があるため、注意して使ってください。これはclangの`-ffast-math`オプションに相当します。
  * `for`ループの前に[`@simd`](@ref)を書くと、各反復が独立しており、順序を変更してもよいことを保証できます。多くの場合、Juliaは`@simd`マクロなしでもコードを自動的にベクトル化できます。このマクロが有効なのは、浮動小数点演算の結合順序の変更を許可する場合や、依存関係のあるメモリアクセスを無視する場合（`@simd ivdep`）など、その指定なしでは変換が許されない場合だけです。繰り返しになりますが、`@simd`を指定する際は十分に注意してください。反復間に依存関係があるループに誤って注釈を付けると、予期しない結果を招く可能性があります。特に、一部の`AbstractArray`サブタイプでは、`setindex!`が本質的に反復順序に依存することに注意してください。**この機能は実験的なもの**であり、将来のJuliaのバージョンで変更または削除される可能性があります。

AbstractArrayのインデックスに1:nを使う一般的な書き方は、配列が通常とは異なるインデックスを使っている場合には安全ではなく、境界チェックを無効にするとセグメンテーション違反が発生する可能性があります。代わりに`LinearIndices(x)`または`eachindex(x)`を使ってください（[Arrays with custom indices](@ref man-custom-indices)も参照）。

!!! note
    `@simd`は、最も内側の`for`ループの直前に置く必要があります。一方、`@inbounds`と`@fastmath`は、単一の式にも、入れ子のコードブロック内に現れるすべての式にも適用できます。たとえば、`@inbounds begin`や`@inbounds for ...`のように使えます。


次は、`@inbounds`と`@simd`の両方の注釈を使った例です（ここでは、最適化処理が過度に賢く働いてベンチマークを無意味にしないよう、`@noinline`を使っています）。

```julia
@noinline function inner(x, y)
    s = zero(eltype(x))
    for i in eachindex(x, y)
        @inbounds s += x[i]*y[i]
    end
    return s
end

@noinline function innersimd(x, y)
    s = zero(eltype(x))
    @simd for i in eachindex(x, y)
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

2.4GHz Intel Core i5プロセッサを搭載したコンピュータでは、次の結果になります。

```
GFlop/sec        = 1.9467069505224963
GFlop/sec (SIMD) = 17.578554163920018
```

（`GFlop/sec`は性能の指標で、数値が大きいほど優れています。）

次は、3種類すべての注釈を使った例です。このプログラムは、まず1次元配列の有限差分を計算し、次にその結果のL2ノルムを求めます。

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

2.7 GHz Intel Core i7プロセッサを搭載したコンピュータでは、次の結果になります。

```
$ julia wave.jl;
  1.207814709 seconds
4.443986180758249

$ julia --math-mode=ieee wave.jl;
  4.487083643 seconds
4.443986180758249
```

ここでは、`--math-mode=ieee`オプションで`@fastmath`マクロを無効にし、結果を比較できるようにしています。

この場合、`@fastmath`によって約3.7倍の高速化が得られています。これは例外的に大きな効果で、一般にはもっと小さくなります。（この例では、ベンチマークの作業データ全体がプロセッサのL1キャッシュに収まるほど小さいため、メモリアクセスのレイテンシが影響せず、計算時間はCPUの処理に支配されます。実際のプログラムの多くでは、こうはなりません。）また、この場合は最適化によって結果が変わりませんが、一般にはわずかに異なる結果になります。特に数値的に不安定なアルゴリズムなどでは、結果が大きく異なる場合もあります。

`@fastmath`注釈は、評価順序の変更や、特定の特殊な値（inf、nan）が現れないと仮定することなどにより、浮動小数点式を再構成します。この例では（このコンピュータ上では）、主な違いは、関数`deriv`内の式`1 / (2*dx)`がループの外に移されることです。つまり、`idx = 1 / (2*dx)`と書いた場合のように、ループの外で計算されます。これにより、ループ内の式`... / (2*dx)`は`... * idx`となり、評価がはるかに高速になります。もちろん、コンパイラが実際に適用する最適化も、得られる高速化の効果も、ハードウェアに大きく依存します。生成されるコードの変化は、Juliaの[`code_native`](@ref)関数を使って確認できます。

なお、`@fastmath`は計算中に`NaN`が現れないことも仮定するため、意外な動作につながる場合があります。

```jldoctest
julia> f(x) = isnan(x);

julia> f(NaN)
true

julia> f_fast(x) = @fastmath isnan(x);

julia> f_fast(NaN)
false
```

### Treat Subnormal Numbers as Zeros

以前は[denormal numbers](https://en.wikipedia.org/wiki/Denormal_number)と呼ばれていた非正規化数は、多くの場面で有用ですが、一部のハードウェアでは性能上のペナルティが発生します。[`set_zero_subnormals(true)`](@ref)を呼び出すと、浮動小数点演算で非正規化数の入力や出力をゼロとして扱うことが許可され、一部のハードウェアでは性能が向上する可能性があります。[`set_zero_subnormals(false)`](@ref)を呼び出すと、非正規化数について厳密なIEEE準拠の動作が強制されます。

次は、一部のハードウェアで非正規化数が性能に明らかな影響を与える例です。

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

次のような出力が得られます。

```
  0.002202 seconds (1 allocation: 4.063 KiB)
  0.001502 seconds (1 allocation: 4.063 KiB)
  0.002139 seconds (1 allocation: 4.063 KiB)
  0.001454 seconds (1 allocation: 4.063 KiB)
  0.002115 seconds (1 allocation: 4.063 KiB)
  0.001455 seconds (1 allocation: 4.063 KiB)
```

偶数回目の反復が、それぞれ大幅に高速になっていることに注目してください。

この例では、`a`の値が指数関数的に減少する曲線となり、時間とともにゆっくり平坦になっていくため、多数の非正規化数が生成されます。

非正規化数をゼロとして扱うと、「`x-y == 0`ならば`x == y`」のような関係が成り立たなくなるため、注意して使う必要があります。

```jldoctest
julia> x = 3f-38; y = 2f-38;

julia> set_zero_subnormals(true); (x - y, x == y)
(0.0f0, false)

julia> set_zero_subnormals(false); (x - y, x == y)
(1.0000001f-38, false)
```

アプリケーションによっては、非正規化数をゼロにする代わりに、ごく小さなノイズを加える方法もあります。たとえば、`a`をゼロで初期化する代わりに、次のように初期化します。

```julia
a = rand(Float32,1000) * 1.f-9
```

### Avoid string interpolation for I/O

ファイル（またはほかのI/Oデバイス）にデータを書き込む際、余分な中間文字列の生成はオーバーヘッドの原因になります。次のコードではなく、

```julia
println(file, "$a $b")
```

次を使ってください。

```julia
println(file, a, " ", b)
```

最初のコードは文字列を生成してからファイルに書き込みますが、2つ目のコードは値を直接ファイルに書き込みます。また、場合によっては文字列補間が読みにくくなることにも注意してください。次の2つを比較してみてください。

```julia
println(file, "$(f(a))$(f(b))")
```

これに対し、次のように書けます。

```julia
println(file, f(a), f(b))
```

### Avoid eager string materialization

オブジェクトの文字列表現が特定の条件下でのみ必要な場合（たとえば、関数のエラー処理経路や、非推奨の警告などの条件付き警告）には、文字列を先に生成するオーバーヘッドを避けることを推奨します。Julia 1.8以降では、[`LazyString`](@ref)と、それに対応する文字列マクロ[`@lazy_str`](@ref)を使って実現できます。

たとえば、次のコードの代わりに、

```julia
Base.depwarn("`foo` is deprecated for type $(typeof(x))", :bar)
```

次を使ってください。

```julia
Base.depwarn(lazy"`foo` is deprecated for type $(typeof(x))", :bar)
```

または、マクロを使わない同等のコードは次のとおりです。

```julia
Base.depwarn(LazyString("`foo` is deprecated for type ", typeof(x)), :bar)
```

この方法では、補間された文字列は実際に表示されるときにだけ構築されます。

### Optimize network I/O during parallel execution

リモート関数を並列実行する場合は、

```julia
using Distributed

responses = Vector{Any}(undef, nworkers())
@sync begin
    for (idx, pid) in enumerate(workers())
        Threads.@spawn responses[idx] = remotecall_fetch(foo, pid, args...)
    end
end
```

次の方法よりも高速です。

```julia
using Distributed

refs = Vector{Any}(undef, nworkers())
for (idx, pid) in enumerate(workers())
    refs[idx] = @spawnat pid foo(args...)
end
responses = [fetch(r) for r in refs]
```

前者では、各ワーカーとのネットワーク通信が1往復で済みます。一方、後者では、まず[`@spawnat`](@ref)によって、次に[`fetch`](@ref)（または[`wait`](@ref)）によって、2回のネットワーク呼び出しが発生します。また、[`fetch`](@ref)/[`wait`](@ref)も逐次実行されるため、全体の性能が低下します。

### [Use `MutableArithmetics` for more control over allocation for mutable arithmetic types](@id man-perftips-mutablearithmetics)

[`BigInt`](@ref)や[`BigFloat`](@ref)など、一部の[`Number`](@ref)サブタイプは、[`mutable struct`](@ref)型として実装されていたり、可変な構成要素を持っていたりします。Juliaの`Base`の算術インターフェースは、このような場合、通常は効率よりも利便性を優先するため、素朴に使うと最適な性能が得られないことがあります。一方、[`MutableArithmetics`](https://juliahub.com/ui/Packages/General/MutableArithmetics)パッケージの抽象化を使うと、このような型の可変性を活用し、必要最小限の割り当てだけを行う高速なコードを書けます。`MutableArithmetics`では、必要に応じて可変な算術型の値を明示的にコピーすることもできます。`MutableArithmetics`はユーザー製のパッケージであり、Juliaプロジェクトとは関係ありません。

# [Performance Tips](@id man-performance-tips)

以下のセクションでは、Julia のコードをできるだけ高速に実行するために役立つ手法をいくつか簡単に紹介します。

## [Table of contents](@id man-performance-tips-toc)

```@contents
Pages = ["performance-tips.md"]
Depth = 3
```

## General advice

### Performance critical code should be inside a function

性能が重要なコードは、すべて関数の中に置くべきです。Julia のコンパイラの仕組みにより、関数内のコードはトップレベルのコードよりも大幅に高速に実行される傾向があります。

関数を使うことは、性能面だけでなく重要です。関数は再利用やテストがしやすく、どのような処理を行い、入力と出力が何であるかを明確にします。また、[Write functions, not just scripts](@ref) は Julia のスタイルガイドでも推奨されています。

関数はグローバル変数を直接操作するのではなく、引数を受け取るようにしてください。次の項目も参照してください。

### Avoid untyped global variables

型注釈のないグローバル変数の値はいつでも変わる可能性があり、その型も変わることがあります。そのため、グローバル変数を使うコードはコンパイラが最適化しにくくなります。これは型を値とする変数、つまりグローバルスコープでの型エイリアスにも当てはまります。可能な限り、変数はローカルにするか、関数の引数として渡してください。

グローバル名は定数であることが多いため、定数として宣言すると性能が大きく向上します。

```julia
const DEFAULT_VAL = 0
```

定数ではないグローバル変数でも、常に同じ型であることが分かっている場合は、[the type should be annotated](@ref man-typed-globals)。`const` グローバル変数は、初期化時の値から型が推論されるため、型注釈は不要です。

型注釈を使えば、型注釈のないグローバル変数の使用を最適化できます。使用箇所で型を注釈します。

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

関数に引数を渡すほうが、よりよいスタイルです。コードの再利用性が高まり、入力と出力も明確になります。

!!! note
    REPL 内のコードはすべてグローバルスコープで評価されるため、トップレベルで定義して代入した変数は**グローバル**変数になります。モジュール内のトップレベルスコープで定義した変数もグローバル変数です。


次の REPL セッションでは、

```jldoctest
julia> x = 1.0
1.0
```

これは次と同じです。

```jldoctest
julia> global x = 1.0
1.0
```

したがって、先ほど説明した性能上の問題はすべて当てはまります。

### Measure performance with [`@time`](@ref) and pay attention to memory allocation

性能を測定する便利なツールとして、[`@time`](@ref) マクロがあります。先ほどのグローバル変数を使った例を、今度は型注釈を外して見てみましょう。

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

最初の呼び出し（`@time sum_global()`）では、関数がコンパイルされます。（このセッションでまだ [`@time`](@ref) を使っていない場合は、計測に必要な関数もコンパイルされます。）この実行結果は参考にしないでください。2回目の実行では、時間の報告に加えて、かなりの量のメモリが割り当てられていることにも注目してください。ここでは64ビット浮動小数点数のベクトルの全要素の合計を計算しているだけなので、（ヒープ）メモリを割り当てる必要はないはずです。

`@time` が報告するのは、厳密には*ヒープ*割り当てです。これは通常、ミュータブルなオブジェクトや、サイズが変わるコンテナ（`Array` や `Dict`、文字列など）、あるいは実行時まで型が分からない「型不安定」なオブジェクトを作成・拡張する際に必要になります。このようなメモリブロックの割り当て（または解放）には、libc の関数呼び出し（C の `malloc` などを介した呼び出し）が必要となり、コストが高くなる場合があります。また、ガベージコレクションのために追跡する必要もあります。一方、数値（多倍長整数を除く）、タプル、イミュータブルな `struct` などのイミュータブルな値は、スタックや CPU レジスタ上のメモリなどに、はるかに低コストで格納できます。そのため、通常はこれらの「割り当て」による性能コストを気にする必要はありません。

予期しないメモリ割り当ては、ほとんどの場合、コードに何らかの問題があることを示しています。多くは型安定性の問題か、小さな一時配列を大量に作成していることが原因です。したがって、割り当てそのものに加えて、関数が生成するコードも最適とは程遠い可能性が高いでしょう。このような兆候を軽視せず、以下の助言に従ってください。

Julia のメモリ管理とガベージコレクションについて詳しくは、[Memory Management and Garbage Collection](@ref man-memory-management) を参照してください。

この例でメモリが割り当てられるのは、型不安定なグローバル変数 `x` を使っているためです。代わりに `x` を関数の引数として渡せば、メモリは割り当てられなくなります（以下で報告される残りの割り当ては、グローバルスコープで `@time` マクロを実行したことによるものです）。また、初回呼び出し後の実行速度も大幅に向上します。

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

表示されている1回の割り当ては、グローバルスコープで `@time` マクロ自体を実行したことによるものです。計測を関数内で行えば、実際には割り当てが発生しないことを確認できます。

```jldoctest sumarg; filter = r"[0-9\.]+ seconds"
julia> time_sum(x) = @time sum_arg(x);

julia> time_sum(x)
  0.000002 seconds
523.0007221951678
```

関数の処理の一部としてメモリを割り当てる必要がある場合もあり、その場合は上記の単純な説明だけでは不十分です。そのようなときは、問題の診断に以下の [tools](@ref tools) のいずれかを使うか、割り当てとアルゴリズム上の処理を分離した関数を作成することを検討してください（[Pre-allocate outputs](@ref) を参照）。

!!! note
    より本格的なベンチマークには、ノイズを減らすために関数を複数回評価するなどの機能を備えた [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) パッケージの利用を検討してください。


### Break functions into multiple definitions

関数を小さな定義に分割して書くと、コンパイラは最も適切なコードを直接呼び出せるようになり、場合によってはインライン化もできます。

次は、複数の定義に分けて書くべき「複合関数」の例です。

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

次のように書けば、より簡潔で効率的になります。

```julia
mynorm(x::Vector) = sqrt(real(dot(x, x)))
mynorm(A::Matrix) = maximum(svdvals(A))
```

ただし、`mynorm` の例のように書かれたコードでも、コンパイラは実行されない分岐をかなり効率よく最適化して取り除けることに注意してください。

### [Tools](@id tools)

Julia とそのパッケージエコシステムには、問題の診断やコードの性能向上に役立つツールがあります。

  * [Profiling](@ref) を使うと、実行中のコードの性能を測定し、ボトルネックとなっている行を特定できます。複雑なプロジェクトでは、[ProfileView](https://github.com/timholy/ProfileView.jl) パッケージを使うと、プロファイリング結果を可視化できます。
  * [JET](https://github.com/aviatesk/JET.jl) パッケージは、コードによくある性能上の問題を見つけるのに役立ちます。
  * [`@time`](@ref)、[`@allocated`](@ref)、またはプロファイラ（ガベージコレクションルーチンの呼び出しを通じて）が報告する、予想外に大きなメモリ割り当ては、コードに問題がある可能性を示しています。割り当ての原因がほかに見当たらない場合は、型の問題を疑ってください。Julia の起動時に `--track-allocation=user` オプションを指定し、生成された `*.mem` ファイルを調べると、割り当てが発生した場所を確認できます。[Memory allocation analysis](@ref) も参照してください。
  * `@code_warntype` は、型が不確定になる式を見つけるのに役立つコード表現を生成します。以下の [`@code_warntype`](@ref) を参照してください。

## Type inference

型宣言を任意に追加できる多くの言語では、宣言を追加することがコードを高速化する主な方法です。しかし、Julia ではそうではありません。Julia のコンパイラは通常、関数の引数、ローカル変数、式の型をすべて把握しています。ただし、宣言が役立つ特定のケースがいくつかあります。

### [Avoid containers with abstract type parameters](@id man-performance-abstract-container)

配列を含むパラメトリック型を使う場合、可能であれば抽象型をパラメータに指定するのは避けるのが最善です。

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

`a` は抽象型 [`Real`](@ref) の配列なので、任意の `Real` 値を格納できなければなりません。`Real` オブジェクトはサイズも構造も任意であるため、`a` は、個別に割り当てられた `Real` オブジェクトへのポインタを並べた配列として表現する必要があります。一方、`a` に格納する値を、たとえば [`Float64`](@ref) のような同じ型の数値だけに限定すれば、より効率的に格納できます。

```jldoctest
julia> a = Float64[]
Float64[]

julia> push!(a, 1); push!(a, 2.0); push!(a,  π)
3-element Vector{Float64}:
 1.0
 2.0
 3.141592653589793
```

`a` に数値を代入すると、`Float64` に変換されるようになります。`a` は、効率よく処理できる64ビット浮動小数点値の連続した領域として格納されます。

抽象型の値を持つコンテナを避けられない場合は、実行時の型チェックを避けるために `Any` でパラメータ化したほうがよいことがあります。たとえば、`IdDict{Any, Any}` は `IdDict{Type, Vector}` よりも高速です。

[Parametric Types](@ref) の説明も参照してください。

### Avoid fields with abstract type

フィールドの型を指定せずに型を宣言することもできます。

```jldoctest myambig
julia> struct MyAmbiguousType
           a
       end
```

これにより、`a` は任意の型を取れるようになります。これは便利な場合も多い一方で、欠点もあります。型 `MyAmbiguousType` のオブジェクトに対して、コンパイラは高性能なコードを生成できません。コンパイラは値ではなくオブジェクトの型を使ってコードの構築方法を決めるためです。残念ながら、型 `MyAmbiguousType` のオブジェクトについて推論できることはほとんどありません。

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

`b` と `c` の値は同じ型ですが、メモリ上のデータ表現は大きく異なります。フィールド `a` に数値だけを格納する場合でも、[`UInt8`](@ref) と [`Float64`](@ref) ではメモリ表現が異なるため、CPU はそれぞれ異なる種類の命令で処理する必要があります。必要な情報が型に含まれていないので、こうした判断は実行時に行わなければなりません。その結果、性能が低下します。

`a` の型を宣言すれば、よりよい結果が得られます。ここでは、`a` が複数の型のいずれかになり得る場合に注目します。この場合、自然な解決策はパラメータを使うことです。たとえば、次のようにします。

```jldoctest myambig2
julia> mutable struct MyType{T<:AbstractFloat}
           a::T
       end
```

これは次の書き方よりも適切です。

```jldoctest myambig2
julia> mutable struct MyStillAmbiguousType
           a::AbstractFloat
       end
```

最初の書き方では、ラッパーオブジェクトの型から `a` の型が分かるためです。たとえば、次のようになります。

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

フィールド `a` の型は `m` の型から容易に判定できますが、`t` の型からは判定できません。実際、`t` では、フィールド `a` の型を変更できます。

```jldoctest myambig2
julia> typeof(t.a)
Float64

julia> t.a = 4.5f0
4.5f0

julia> typeof(t.a)
Float32
```

一方、`m` を構築した後は、`m.a` の型を変更できません。

```jldoctest myambig2
julia> m.a = 4.5f0
4.5f0

julia> typeof(m.a)
Float64
```

`m.a` の型が `m` の型から分かり、さらに関数の実行中にその型が変わらないため、コンパイラは `m` のようなオブジェクトには高度に最適化されたコードを生成できます。しかし、`t` のようなオブジェクトには生成できません。

もちろん、これは `m` を具象型で構築した場合に限ります。抽象型を明示的に指定して構築すると、この性質は失われます。

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

実用上、このようなオブジェクトは `MyStillAmbiguousType` のオブジェクトと同じように振る舞います。

単純な関数に対して生成されるコードの量を比較すると、違いがよく分かります。

```julia
func(m::MyType) = m.a+1
```

次を使った場合です。

```julia
code_llvm(func, Tuple{MyType{Float64}})
code_llvm(func, Tuple{MyType{AbstractFloat}})
```

長くなるため結果はここには示しませんが、ぜひ自分で試してみてください。最初のケースでは型が完全に指定されているため、コンパイラは実行時に型を解決するコードを生成する必要がありません。その結果、コードが短くなり、実行も速くなります。

また、パラメータが完全に指定されていない型は、抽象型のように振る舞うことにも注意してください。たとえば、完全に指定された `Array{T,n}` は具象型ですが、パラメータを指定していない `Array` 自体は具象型ではありません。

```jldoctest myambig3
julia> !isconcretetype(Array), !isabstracttype(Array), isstructtype(Array), !isconcretetype(Array{Int}), isconcretetype(Array{Int,1})
(true, true, true, true, true)
```

この場合、`MyType` のフィールドを `a::Array` として宣言するのではなく、`a::Array{T,N}` または `a::A` として宣言するほうが適切です。このとき、`{T,N}` または `A` は `MyType` のパラメータです。

ここまでの助言は、構造体のフィールドが関数、またはより一般に呼び出し可能なオブジェクトである場合に特に役立ちます。次のように構造体を定義したくなるかもしれません。

```julia
struct MyCallableWrapper
    f::Function
end
```

しかし、`Function` は抽象型なので、フィールド `f` へのアクセスが型不安定になり、`wrapper.f` を呼び出すたびに動的ディスパッチが必要になります。代わりに、次のように書いてください。

```julia
struct MyCallableWrapper{F}
    f::F
end
```

動作はほぼ同じですが、型不安定性がなくなるため、はるかに高速になります。`F<:Function` を制約していない点にも注意してください。つまり、`Function` のサブタイプではない呼び出し可能オブジェクトも、フィールド `f` に指定できます。

### Avoid fields with abstract containers

同じベストプラクティスはコンテナ型にも当てはまります。

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

`MySimpleContainer` では、オブジェクトの型とパラメータによってその内容が完全に指定されるため、コンパイラは最適化された関数を生成できます。ほとんどの場合、これで十分でしょう。

コンパイラが適切に処理できるようになった一方で、`a` の*要素型*に応じてコードの動作を変えたい場合もあるでしょう。通常は、ここでの `foo` のような特定の処理を、別の関数に分けるのが最善です。

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

こうすればコードをシンプルに保ちながら、どの場合にもコンパイラが最適化されたコードを生成できます。

ただし、要素型や、`MySimpleContainer` におけるフィールド `a` の `AbstractVector` の型に応じて、外側の関数に異なる定義を用意する必要がある場合もあります。たとえば、次のようにできます。

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

任意の型の値を含められるデータ構造（型 `Array{Any}` の配列）を使うと便利なことがよくあります。しかし、そのような構造を使っていて、要素の型が分かっている場合は、その情報をコンパイラに伝えると役立ちます。

```julia
function foo(a::Array{Any,1})
    x = a[1]::Int32
    b = x+1
    ...
end
```

ここでは、`a` の最初の要素が [`Int32`](@ref) であると分かっています。このように注釈すると、値が期待した型でない場合に実行時エラーが発生するため、特定のバグを早期に検出できるという利点もあります。

`a[1]` の型を正確に特定できない場合は、`x` を `x = convert(Int32, a[1])::Int32` で宣言できます。[`convert`](@ref) 関数を使うと、`a[1]` は `Int32` に変換可能な任意のオブジェクト（たとえば `UInt8`）を受け取れるため、型の要件が緩和され、コードの汎用性が高まります。この場合、型安定性を確保するには `convert` 自体にも型注釈が必要です。これは、関数のすべての引数の型が分かっていない限り、コンパイラは `convert` であっても関数の戻り値の型を推論できないためです。

型が抽象型である場合や、実行時に構築される場合、型注釈を付けても性能は向上しません（かえって低下することもあります）。コンパイラはその注釈を使って後続のコードを特殊化できず、型チェック自体にも時間がかかるためです。たとえば、次のコードでは、

```julia
function nr(a, prec)
    ctype = prec == 32 ? Float32 : Float64
    b = Complex{ctype}(a)
    c = (b + 1.0f0)::Complex{ctype}
    abs(c)
end
```

`c` の型注釈は性能を低下させます。実行時に構築される型を使って高性能なコードを書くには、以下で説明する [function-barrier technique](@ref kernel-functions) を使い、カーネル関数の引数型に構築した型が含まれるようにしてください。そうすれば、カーネル内の処理がコンパイラによって適切に特殊化されます。たとえば、上のコードでは `b` を構築したら、それをカーネルとなる別の関数 `k` に渡せます。たとえば、関数 `k` が `b` を型 `Complex{T}` の引数として宣言し、`T` を型パラメータとする場合、`k` 内の代入文に次のような型注釈を付けても、

```julia
c = (b + 1.0f0)::Complex{T}
```

性能は低下しません（ただし、向上もしません）。`k` のコンパイル時に、コンパイラが `c` の型を特定できるためです。

### Be aware of when Julia avoids specializing

経験則として、Julia は次の3つの場合、引数の型パラメータに対する自動的な [specializing](@ref man-method-specializations) を避けます。`Type`、`Function`、`Vararg` です。引数がメソッド内で使われる場合、Julia は常に特殊化しますが、別の関数にそのまま渡すだけの場合は特殊化しません。通常、これは実行時の性能に影響せず、[improves compiler performance](@ref compiler-efficiency-issues)。ただし、実行時の性能に影響していることが分かった場合は、メソッド宣言に型パラメータを追加して特殊化を促せます。例を示します。

これは特殊化されません。

```julia
function f_type(t)  # or t::Type
    x = ones(t, 10)
    return sum(map(sin, x))
end
```

一方、こちらは特殊化されます。

```julia
function g_type(t::Type{T}) where T
    x = ones(T, 10)
    return sum(map(sin, x))
end
```

次のものは特殊化されません。

```julia
f_func(f, num) = ntuple(f, div(num, 2))
g_func(g::Function, num) = ntuple(g, div(num, 2))
```

一方、こちらは特殊化されます。

```julia
h_func(h::H, num) where {H} = ntuple(h, div(num, 2))
```

これは特殊化されません。

```julia
f_vararg(x::Int...) = tuple(x...)
```

一方、こちらは特殊化されます。

```julia
g_vararg(x::Vararg{Int, N}) where {N} = tuple(x...)
```

ほかの型に制約がなくても、特殊化を強制するには型パラメータを1つ導入するだけで十分です。たとえば、次のコードも特殊化されます。引数の型がすべて同じではない場合に便利です。

```julia
h_vararg(x::Vararg{Any, N}) where {N} = tuple(x...)
```

[`@code_typed`](@ref) などは、Julia が通常そのメソッド呼び出しを特殊化しない場合でも、常に特殊化されたコードを表示することに注意してください。引数の型を変えたときに特殊化が生成されるか、つまり `Base.specializations(@which f(...))` に対象の引数に対する特殊化が含まれているかを確認するには、[method internals](@ref ast-lowered-method) を調べる必要があります。

### Write "type-stable" functions

可能であれば、関数が常に同じ型の値を返すようにするとよいでしょう。次の定義を考えてみます。

```julia
pos(x) = x < 0 ? 0 : x
```

一見問題なさそうですが、`0` は整数（型 `Int`）である一方、`x` は任意の型になり得ます。そのため、`x` の値によって、この関数は2種類の型のいずれかの値を返す可能性があります。この動作は許容されており、場合によっては望ましいこともあります。しかし、次のようにすれば簡単に修正できます。

```julia
pos(x) = x < 0 ? zero(x) : x
```

[`oneunit`](@ref) 関数と、より汎用的な [`oftype(x, y)`](@ref) 関数もあります。後者は `y` を `x` の型に変換して返します。

### Avoid changing the type of a variable

関数内で繰り返し使われる変数にも、同様の「型安定性」の問題が起こります。

```julia
function foo()
    x = 1
    for i = 1:10
        x /= rand()
    end
    return x
end
```

ローカル変数 `x` は最初は整数ですが、ループを1回実行すると浮動小数点数（[`/`](@ref) 演算子の結果）になります。そのため、コンパイラはループ本体を最適化しにくくなります。修正方法はいくつかあります。

  * `x` を `x = 1.0` で初期化する
  * `x` の型を `x::Float64 = 1` と明示的に宣言する
  * `x = oneunit(Float64)` で明示的に変換する
  * 最初のループ反復で `x = 1 / rand()` に初期化し、その後 `for i = 2:10` をループする

### [Separate kernel functions (aka, function barriers)](@id kernel-functions)

多くの関数は、準備処理を行った後、中心となる計算を繰り返し実行する構成になっています。可能であれば、この中心的な計算を別の関数に分けるとよいでしょう。たとえば、次の例はランダムに選ばれた型の配列を返す、説明用の関数です。

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

次のように書くべきです。

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

Julia のコンパイラは関数の境界で引数の型に応じてコードを特殊化します。元の実装では、ループ中に `a` の型が分かりません（ランダムに選ばれるため）。そのため、2つ目の書き方のほうが一般に高速です。内側のループは、`a` の型ごとに `fill_twos!` の一部として再コンパイルできるからです。

2つ目の書き方は、スタイルとしても優れていることが多く、コードの再利用性も高まります。

このパターンは Julia Base のいくつかの箇所で使われています。たとえば、[`abstractarray.jl`](https://github.com/JuliaLang/julia/blob/40fe264f4ffaa29b749bcf42239a89abdcbba846/base/abstractarray.jl#L1205-L1206) の `vcat` と `hcat` を参照してください。また、独自の `fill_twos!` を書く代わりに使えた [`fill!`](@ref) 関数も同様です。

`strange_twos` のような関数は、たとえば整数、浮動小数点数、文字列など、さまざまな型のデータが含まれる可能性のある入力ファイルからデータを読み込む場合など、型が不確かなデータを扱うときに使われます。

### [[`@code_warntype`](@ref)](@id man-code-warntype)

[`@code_warntype`](@ref) マクロ（または関数版の [`code_warntype`](@ref)）は、型に関する問題の診断に役立つことがあります。例を示します。

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

[`@code_warntype`](@ref) の出力を読み解くには、関連する [`@code_lowered`](@ref)、[`@code_typed`](@ref)、[`@code_llvm`](@ref)、[`@code_native`](@ref) と同様、少し慣れが必要です。表示されるのは、コンパイル済み機械語を生成するまでに大幅な変換を受けたコードです。ほとんどの式には型が注釈されており、`::T` で示されます（たとえば `T` は [`Float64`](@ref) になることがあります）。[`@code_warntype`](@ref) で最も重要なのは、具象型でない型が赤色で表示されることです。この文書は色を表現できない Markdown で書かれているため、ここでは赤い文字を大文字で表します。

先頭には、推論された関数の戻り値の型が `Body::Float64` として表示されます。続く行は、Julia の SSA IR 形式で表した `f` の本体です。番号付きの枠はラベルであり、コード内のジャンプ（`goto` を介したジャンプ）の飛び先を表します。本体を見ると、最初に `pos` が呼び出され、その戻り値の型は `Union` と推論されています。表示されている `Union{Float64, Int64}` は具象型ではないため、大文字で示されています。つまり、入力の型だけから `pos` の正確な戻り値の型を特定できません。しかし、`y*x` の結果は、`y` が `Float64` でも `Int64` でも、`Float64` です。つまり、中間計算の一部が型不安定でも、`f(x::Float64)` の出力は型不安定になりません。

この情報をどう活用するかは、状況によります。もちろん、`pos` を型安定に修正できれば最善です。そうすれば、`f` 内の変数はすべて具象型になり、性能も最適になります。ただし、この種の*一時的な*型不安定性が大きな問題にならない場合もあります。たとえば、`pos` が単独で使われない場合、[`Float64`](@ref) 入力に対して `f` の出力が型安定であれば、型不安定性が後続のコードに波及するのを防げます。型不安定性の修正が難しい、または不可能な場合には特に重要です。そのような場合は、上記の助言（型注釈の追加や関数の分割など）を使って、型不安定性による「損害」を抑えるのが最善です。また、Julia Base にも型不安定な関数があることに注意してください。たとえば [`findfirst`](@ref) 関数は、配列内でキーが見つかった位置のインデックスを返し、見つからない場合は `nothing` を返します。これは明らかな型不安定性です。重要な型不安定性を見つけやすくするため、`missing` または `nothing` を含む `Union` は、赤ではなく黄色で強調表示されます。

次の例は、具象型でない型を含むと印が付いた式を読み解く際に役立ちます。

  * `Body::Union{T1,T2})` で始まる関数本体

      * 解釈: 戻り値の型が不安定な関数
      * 対処法: 必要であれば型注釈を付けてでも、戻り値を型安定にする
  * `invoke Main.g(%%x::Int64)::Union{Float64, Int64}`

      * 解釈: 型不安定な関数 `g` の呼び出し
      * 対処法: 関数を修正するか、必要であれば戻り値に型注釈を付ける
  * `invoke Base.getindex(%%x::Array{Any,1}, 1::Int64)::Any`

      * 解釈: 型の適切でない配列の要素へのアクセス
      * 対処法: より明確な型を持つ配列を使うか、必要であれば個々の要素アクセスに型注釈を付ける
  * `Base.getfield(%%x, :(:data))::Array{Float64,N} where N`

      * 解釈: 具象型でない型のフィールドへのアクセス。この場合、たとえば型 `x`（`ArrayContainer`）にはフィールド `data::Array{T}` がありました。しかし、`Array` では、次元 `N` も具象型である必要があります。
      * 対処法: `Array{T,3}` や `Array{T,N}` のような具象型を使う。この場合、`N` は `ArrayContainer` のパラメータになります。

### [Performance of captured variable](@id man-performance-captured)

次の例では、内部関数を定義しています。

```julia
function abmult(r::Int)
    if r < 0
        r = -r
    end
    f = x -> x * r
    return f
end
```

関数 `abmult` は、引数に `r` の絶対値を掛ける関数 `f` を返します。`f` に代入された内部関数は「クロージャ」と呼ばれます。内部関数は、`do` ブロックやジェネレータ式にも使われます。

このようなコードは、言語の性能に課題をもたらします。パーサーはコードを低水準の命令に変換する際、内部関数を別のコードブロックに切り出すなど、上記のコードを大幅に再構成します。また、内部関数と外側のスコープで共有される `r` のような「キャプチャされた」変数も、ヒープに割り当てられる「ボックス」に切り出され、内部関数と外部関数の両方からアクセスできるようになります。これは、外側のスコープ（または別の内部関数）が `r` を変更した後でも、内部スコープの `r` が外側スコープの `r` と同一であることを言語が保証するためです。

前段落で述べた「パーサー」とは、`abmult` を含むモジュールが最初に読み込まれるときに行われるコンパイル段階を指します。これは、関数が初めて呼び出されるときの後続段階とは異なります。パーサーは、`Int` が固定された型であることも、`r = -r` が `Int` を別の `Int` に変換することも「知りません」。型推論の仕組みが働くのは、後続のコンパイル段階です。

そのため、パーサーは `r` の型が固定されている（`Int`）ことも、内部関数の作成後に `r` の値が変わらない（したがってボックスが不要である）ことも分かりません。そこでパーサーは、`Any` のような抽象型のオブジェクトを保持するボックス用のコードを生成します。その結果、`r` が現れるたびに実行時の型ディスパッチが必要になります。上記の関数に `@code_warntype` を適用すると確認できます。ボックス化と実行時の型ディスパッチは、どちらも性能低下の原因になります。

キャプチャされた変数を性能が重要なコードで使う場合は、次の助言に従うと性能を確保しやすくなります。まず、キャプチャされた変数の型が変わらないと分かっている場合は、変数自体に型注釈を付けて明示できます（右辺ではなく変数に付けます）。

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

型注釈を付けると、パーサーがボックス内のオブジェクトに具象型を関連付けられるため、キャプチャによる性能低下を部分的に取り戻せます。さらに、クロージャの作成後に再代入されないため、キャプチャされた変数をボックス化する必要がない場合は、次のように `let` ブロックでそのことを示せます。

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

`let` ブロックは、スコープが内部関数内に限られる新しい変数 `r` を作成します。2つ目の方法を使うと、キャプチャされた変数があっても言語本来の性能を完全に取り戻せます。これはコンパイラの開発が急速に進んでいる分野であり、将来のリリースでは、性能を得るためにここまでプログラマーが注釈を付ける必要はなくなる可能性があります。それまでの間は、[FastClosures](https://github.com/c42f/FastClosures.jl) のようなユーザー提供パッケージを使うと、`abmult3` のような `let` 文の挿入を自動化できます。

#### Use `@__FUNCTION__` for recursive closures

再帰クロージャに限って言えば、[`@__FUNCTION__`](@ref) マクロを使うと、型不安定性とボックス化の両方を避けられます。

まず、最適化されていないバージョンを見てみましょう。

```julia
function make_fib_unoptimized()
    fib(n) = n <= 1 ? 1 : fib(n - 1) + fib(n - 2)  # fib is boxed
    return fib
end
```

`fib` 関数はボックス化されているため、戻り値の型は `Any` と推論されます。

```julia
@code_warntype make_fib_unoptimized()
```

この型不安定性をなくすには、代わりに `@__FUNCTION__` を使って具象関数オブジェクトを参照します。

```julia
function make_fib_optimized()
    fib(n) = n <= 1 ? 1 : (@__FUNCTION__)(n - 1) + (@__FUNCTION__)(n - 2)
    return fib
end
```

これにより、戻り値の型が具象型になります。

```julia
@code_warntype make_fib_optimized()
```

### [Types with values-as-parameters](@id man-performance-value-type)

各軸のサイズが3の `N` 次元配列を作りたいとします。このような配列は、次のように作成できます。

```jldoctest
julia> A = fill(5.0, (3, 3))
3×3 Matrix{Float64}:
 5.0  5.0  5.0
 5.0  5.0  5.0
 5.0  5.0  5.0
```

この方法は非常にうまく機能します。コンパイラは、埋める値（`5.0::Float64`）の型と次元数（`(3, 3)::NTuple{2,Int}`）から、`A` が `Array{Float64,2}` であると判断できます。そのため、同じ関数内で `A` を後から使う際にも、非常に効率的なコードを生成できます。

では、任意の次元数で3×3×...の配列を作る関数を書きたいとします。次のように書きたくなるかもしれません。

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

これは動作しますが、`@code_warntype array3(5.0, 2)` を使って確認できるように、出力の型を推論できないという問題があります。引数 `N` は型 `Int` の*値*であり、型推論ではその値を事前に予測できません（また、予測することもできません）。そのため、この関数の出力を使うコードは、`A` にアクセスするたびに型を確認する必要があり、非常に遅くなります。

このような問題を解決する非常に有効な方法の1つは、[function-barrier technique](@ref kernel-functions) を使うことです。ただし、型不安定性を完全になくしたい場合もあります。その場合は、たとえば `Val{T}()` を通じて、次元数をパラメータとして渡す方法があります（["Value types"](@ref) を参照）。

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

Julia には、2つ目のパラメータとして `Val{::Int}` のインスタンスを受け取る `ntuple` の特殊化版があります。`N` を型パラメータとして渡すと、その「値」がコンパイラに分かります。その結果、この版の `array3` では、コンパイラが戻り値の型を予測できます。

ただし、このような手法の使い方には、意外と注意が必要です。たとえば、次のような関数から `array3` を呼び出しても役に立ちません。

```julia
function call_array3(fillval, n)
    A = array3(fillval, Val(n))
end
```

ここでは同じ問題が再び起きています。コンパイラは `n` が何かを推測できないため、`Val(n)` の*型*も分かりません。`Val` を誤った方法で使うと、多くの場合、かえって性能が*低下*します。（上記のようなコードを使うべきなのは、関数バリアの手法と `Val` を実質的に組み合わせて、カーネル関数を効率化する場合に限られます。）

`Val` の正しい使い方の例は次のとおりです。

```julia
function filter3(A::AbstractArray{T,N}) where {T,N}
    kernel = array3(1, Val(N))
    filter(A, kernel)
end
```

この例では、`N` がパラメータとして渡されるため、その「値」がコンパイラに分かります。つまり、`Val(T)` が機能するのは、`T` がハードコードされたリテラル（`Val(3)`）であるか、すでに型の領域で指定されている場合に限られます。

### The dangers of abusing multiple dispatch (aka, more on types with values-as-parameters)

多重ディスパッチの利点が分かると、何にでも使いたくなるのは無理もありません。たとえば、次のように情報を格納し、

```
struct Car{Make, Model}
    year::Int
    ...more fields...
end
```

`Car{:Honda,:Accord}(year, args...)` のようなオブジェクトに対してディスパッチすることを考えるかもしれません。

次のいずれかに当てはまる場合は、有効な方法かもしれません。

  * 各 `Car` に対して CPU 負荷の高い処理を行い、`Make` と `Model` がコンパイル時に分かっていると処理が大幅に効率化され、使用する `Make` または `Model` の種類も多すぎない。
  * 同じ型の `Car` を並べた均質なリストを処理するため、それらをすべて `Array{Car{:Honda,:Accord},N}` に格納できる。

後者の場合、そのような均質な配列を処理する関数は、効果的に特殊化できます。コンテナ内のオブジェクトはすべて同じ具象型なので、Julia は各要素の型を事前に把握できます。そのため、関数のコンパイル時に適切なメソッド呼び出しを「検索」でき、実行時の確認が不要になり、リスト全体を効率よく処理するコードを生成できます。

これらの条件に当てはまらない場合、利点は得られない可能性が高く、むしろ「型の組み合わせ爆発」が逆効果になります。`items[i+1]` の型が `item[i]` と異なる場合、Julia は実行時に型を調べ、メソッドテーブルから適切なメソッドを検索し、型の共通部分を使ってどのメソッドが一致するかを判断し、JIT コンパイル済みかどうかを確認し、未コンパイルならコンパイルしてから呼び出す必要があります。つまり、自分のコードで switch 文や辞書検索を実行する代わりに、型システムと JIT コンパイルの仕組み全体を使って同等の処理を実行させていることになります。

(1) 型ディスパッチ、(2) 辞書検索、(3)「switch」文を比較した実行時ベンチマークは、[on discourse](https://discourse.julialang.org/t/suggestion-updating-the-dispatch-vs-dict-switch-benchmark-link-in-the-manual/132159) にあります。

実行時の影響よりさらに深刻なのは、コンパイル時の影響かもしれません。Julia は `Car{Make, Model}` ごとに特殊化された関数をコンパイルします。このような型が数百、数千あると、カスタムの `get_year` 関数から Julia Base の汎用 `push!` 関数まで、そのオブジェクトを引数に取るすべての関数について、数百、数千ものバリエーションがコンパイルされます。それぞれがコンパイル済みコードのキャッシュや内部のメソッドリストなどを肥大化させます。値を型パラメータとして使いすぎると、膨大なリソースを無駄にしかねません。

## Memory management and arrays

### Pre-allocate outputs

関数が `Array` やその他の複雑な型を返す場合、メモリの割り当てが必要になることがあります。残念ながら、割り当てと、その逆の処理であるガベージコレクションが、大きなボトルネックになることは少なくありません。

関数呼び出しごとのメモリ割り当ては、出力を事前に確保することで回避できる場合があります。簡単な例として、次を比較してください。

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

こちらと、

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

計測結果は次のとおりです。

```jldoctest prealloc; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> @time loopinc()
  0.297454 seconds (200.00 k allocations: 2.239 GiB, 39.80% gc time)
5000250000

julia> @time loopinc_prealloc()
  0.009410 seconds (2 allocations: 23.477 KiB)
5000250000
```

事前確保には、アルゴリズムの「出力」型を呼び出し側が制御できるなど、ほかの利点もあります。上の例では、必要であれば [`Array`](@ref) ではなく `SubArray` を渡すこともできました。

事前確保を徹底しすぎるとコードが読みにくくなるため、性能測定と判断が必要です。ただし、「ベクトル化された」（要素ごとの）関数では、便利な構文 `x .= f.(y)` を使うと、一時配列を作らず、ループを融合したインプレース演算を行えます（[dot syntax for vectorizing functions](@ref man-vectorized) を参照）。

### [Consider using views for slices](@id man-performance-views)

Julia では、`array[1:5, :]` のような配列の「スライス」式は、データのコピーを作成します（代入の左辺では例外で、`array[1:5, :] = ...` が `array` の該当部分にインプレースで代入します）。スライスに対して多くの処理を行う場合は、元の配列をインデックスで参照するより、小さく連続したコピーを使うほうが効率的なので、性能向上につながることがあります。一方、スライスに対して簡単な処理を少し行うだけなら、割り当てとコピーのコストが大きくなる場合があります。

別の方法として、配列の「ビュー」を作成できます。ビューは配列オブジェクト（`SubArray`）であり、コピーを作らずに元の配列のデータをその場で参照します。（ビューに書き込むと、元の配列のデータも変更されます。）個々のスライスには [`view`](@ref) を呼び出してビューを作成できます。また、式やコードブロック全体に対しては、その前に [`@views`](@ref) を付けるだけで、より簡単にビューを作成できます。たとえば、次のようになります。

```jldoctest; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> fcopy(x) = sum(x[2:end-1]);

julia> @views fview(x) = sum(x[2:end-1]);

julia> x = rand(10^6);

julia> @time fcopy(x);
  0.003051 seconds (3 allocations: 7.629 MB)

julia> @time fview(x);
  0.001020 seconds (1 allocation: 16 bytes)
```

`fview` 版の関数では、速度が3倍になり、メモリ割り当ても減っていることに注目してください。

### Consider StaticArrays.jl for small fixed-size vector/matrix operations

固定サイズ（つまり、実行前にサイズが分かっている）の小さな `< 100` 要素配列を大量に扱う場合は、[StaticArrays.jl package](https://github.com/JuliaArrays/StaticArrays.jl) の利用を検討してください。このパッケージを使うと、不要なヒープ割り当てを避け、配列の*サイズ*に応じてコンパイラがコードを特殊化できる形で配列を表現できます。たとえば、ベクトル演算を完全に展開してループをなくしたり、要素を CPU レジスタに格納したりできます。

たとえば、2次元幾何の計算を行う場合、2成分ベクトルを使った計算が多数あるかもしれません。StaticArrays.jl の `SVector` 型を使えば、ベクトル `v` と `w` に対して、`norm(3v - w)` のような便利なベクトル表記や演算を使いながら、コンパイラにコードを展開させ、`@inbounds hypot(3v[1]-w[1], 3v[2]-w[2])` と同等の最小限の計算にできます。

### More dots: Fuse vectorized operations

Julia には、スカラー関数を「ベクトル化された」関数呼び出しに、演算子を「ベクトル化された」演算子に変換する特別な [dot syntax](@ref man-vectorized) があります。入れ子になった「ドット呼び出し」は融合され、構文レベルで1つのループにまとめられるため、一時配列は割り当てられません。`.=` などの代入演算子を使えば、事前確保した配列に結果をインプレースで格納することもできます（上記を参照）。

線形代数では、`vector + vector` や `vector * scalar` のような演算が定義されていても、代わりに `vector .+ vector` や `vector .* scalar` を使うと、周囲の計算とループを融合できるため有利な場合があります。たとえば、次の2つの関数を考えてみましょう。

```jldoctest dotfuse
julia> f(x) = 3x.^2 + 4x + 7x.^3;

julia> fdot(x) = @. 3x^2 + 4x + 7x^3; # equivalent to 3 .* x.^2 .+ 4 .* x .+ 7 .* x.^3
```

`f` と `fdot` は同じ計算を行います。しかし、配列に適用した場合、`fdot`（[`@.`](@ref @__dot__) マクロを使って定義）は大幅に高速です。

```jldoctest dotfuse; filter = r"[0-9\.]+ seconds \(.*?\)"
julia> x = rand(10^6);

julia> @time f(x);
  0.019049 seconds (16 allocations: 45.777 MiB, 18.59% gc time)

julia> @time fdot(x);
  0.002790 seconds (6 allocations: 7.630 MiB)

julia> @time f.(x);
  0.002626 seconds (8 allocations: 7.630 MiB)
```

つまり、`fdot(x)` は `f(x)` の10倍速く、メモリ割り当ては6分の1です。これは、`f(x)` 内の各 `*` と `+` 演算が新しい一時配列を割り当て、別々のループで実行されるためです。この例では `f.(x)` は `fdot(x)` と同じ速さですが、多くの場合、ベクトル化された演算ごとに関数を定義するより、式にドットを付けるほうが便利です。

### [Fewer dots: Unfuse certain intermediate broadcasts](@id man-performance-unfuse)

前述のドット演算のループ融合を使うと、簡潔で慣用的なコードで高性能な処理を表現できます。ただし、融合された演算はブロードキャストの反復ごとに計算されることを忘れないでください。そのため、特に合成されたブロードキャストや多次元ブロードキャストでは、ドット呼び出しを含む式が意図した回数より多く関数を計算する場合があります。例として、各行のユークリッドノルムが1となるランダム行列を作りたいとします。次のように書けるでしょう。

```
julia> x = rand(1000, 1000);

julia> d = sum(abs2, x; dims=2);

julia> @time x ./= sqrt.(d);
  0.002049 seconds (4 allocations: 96 bytes)
```

これは動作します。しかし、この式では行 `x[i, :]` の各要素について `sqrt(d[i])` が再計算されるため、必要以上に多くの平方根が計算されます。ブロードキャストがどのインデックスを反復するかを正確に確認するには、融合式の引数に対して `Broadcast.combine_axes` を呼び出します。これは反復軸に対応する範囲のタプルを返します。各範囲の長さの積が、融合演算の呼び出し総数になります。

したがって、ブロードキャスト式の一部がある軸に沿って一定である場合（先ほどの例では、第2次元に沿った `sqrt`）、その部分を意図的に「融合解除」すると性能が向上する可能性があります。つまり、ブロードキャスト演算の結果をあらかじめ割り当て、一定の軸に沿ってキャッシュした値を再利用します。方法としては、一時変数を使う、ドット式の一部を `identity` で囲む、または同等の組み込みベクトル化関数（ただし融合はしない）を使うことなどが考えられます。

```
julia> @time let s = sqrt.(d); x ./= s end;
  0.000809 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= identity(sqrt.(d));
  0.000608 seconds (5 allocations: 8.031 KiB)

julia> @time x ./= map(sqrt, d);
  0.000611 seconds (4 allocations: 8.016 KiB)
```

これらの方法はいずれも、メモリ割り当てが発生する代わりに、およそ3倍の高速化をもたらします。ブロードキャスト対象が大きい場合、この高速化は漸近的に非常に大きくなることがあります。

### [Access arrays in memory order, along columns](@id man-performance-column-major)

Julia の多次元配列は列優先順で格納されます。つまり、配列は列ごとに並べられます。これは `vec` 関数や、以下に示す `[:]` 構文で確認できます（配列が `[1 3 2 4]` の順に並び、`[1 2 3 4]` の順ではないことに注目してください）。

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

この配列順序は、Fortran、Matlab、R など多くの言語で一般的です。列優先順の対となる行優先順は、C や Python（`numpy`）などで採用されています。配列をループ処理する際、順序を意識することは性能に大きく影響します。覚えておくべき経験則は、列優先配列では最初のインデックスが最も速く変化するということです。つまり、スライス式で最初に現れるインデックスを最内ループのインデックスにすると、ループが高速になります。`:` で配列をインデックス指定すると、特定の次元の全要素に順次アクセスする暗黙のループが発生することにも注意してください。たとえば、行より列を取り出すほうが高速な場合があります。

次の説明用の例を考えてみましょう。[`Vector`](@ref) を受け取り、入力ベクトルのコピーで行または列を埋めた正方形の [`Matrix`](@ref) を返す関数を書きたいとします。行と列のどちらにコピーを入れるかは重要でないとします（たとえば、残りのコードを簡単に調整できる場合です）。組み込みの [`repeat`](@ref) を呼び出す推奨方法のほかに、少なくとも4通りの方法が考えられます。

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

次に、同じランダムな `10000` × `1` の入力ベクトルを使って、各関数の実行時間を測定します。

```julia-repl
julia> x = randn(10000);

julia> fmt(f) = println(rpad(string(f)*": ", 14, ' '), @elapsed f(x))

julia> map(fmt, [copy_cols, copy_rows, copy_col_row, copy_row_col]);
copy_cols:    0.331706323
copy_rows:    1.799009911
copy_col_row: 0.415630047
copy_row_col: 1.721531501
```

`copy_cols` が `copy_rows` よりはるかに高速であることに注目してください。これは予想どおりです。`copy_cols` は `Matrix` の列優先メモリ配置に従い、列ごとに値を埋めるためです。また、`copy_col_row` は `copy_row_col` よりもはるかに高速です。これは、スライス式に最初に現れる要素を最内ループに対応させるという経験則に従っているためです。

### Copying data is not always bad

配列はメモリ上に連続して格納されるため、CPU のベクトル化や、キャッシュによるメモリアクセス回数の削減に適しています。これらは、配列を列優先順でアクセスすることが推奨される理由（上記を参照）と同じです。不規則なアクセスパターンや非連続なビューは、メモリに順次アクセスできなくなるため、配列処理を大幅に遅くすることがあります。

不規則にアクセスするデータを連続した配列にコピーしてから繰り返しアクセスすると、以下の例のように大幅な高速化につながることがあります。ここでは、行列をランダムに並べ替えたインデックスで参照してから乗算しています。コピーと割り当てのコストを加えても、通常の配列にコピーすることで乗算が高速になります。

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

十分なメモリがあれば、ビューを配列にコピーするコストは、連続した配列に対して行列乗算を繰り返すことで得られる速度向上によって補えます。

### [Multithreading and linear algebra](@id man-multithreading-linear-algebra)

このセクションは、各スレッドで線形代数演算を行うマルチスレッド Julia コードを対象としています。線形代数演算は BLAS / LAPACK を呼び出し、これら自体もマルチスレッドで動作します。そのため、2種類のマルチスレッド処理によってコアが過剰に割り当てられないようにする必要があります。

Julia は線形代数用に独自の OpenBLAS をコンパイルして使用します。そのスレッド数は環境変数 `OPENBLAS_NUM_THREADS` で制御します。Julia の起動時にコマンドラインオプションとして設定するか、Julia セッション中に `BLAS.set_num_threads(N)` で変更できます（サブモジュール `BLAS` は `using LinearAlgebra` によってエクスポートされています）。現在の値は `BLAS.get_num_threads()` で取得できます。

ユーザーが何も指定しない場合、Julia はプラットフォームや Julia のバージョンなどに基づいて、OpenBLAS のスレッド数として妥当な値を選ぼうとします。ただし、値を手動で確認して設定することを一般に推奨します。OpenBLAS の動作は次のとおりです。

  * `OPENBLAS_NUM_THREADS=1` の場合、OpenBLAS は呼び出し元の Julia スレッドを使います。つまり、計算を実行する Julia スレッド内で動作します。
  * `OPENBLAS_NUM_THREADS=N>1` の場合、OpenBLAS は独自のスレッドプール（合計 `N` 個）を作成して管理します。すべての Julia スレッドで共有される OpenBLAS のスレッドプールは1つだけです。

`JULIA_NUM_THREADS=X` を指定して Julia をマルチスレッドモードで起動する場合は、通常 `OPENBLAS_NUM_THREADS=1` を設定することを推奨します。上記の動作を踏まえると、BLAS のスレッド数を `N>1` に増やすと、特に `N<<X` の場合、性能が簡単に低下する可能性があります。ただし、これはあくまで経験則です。スレッド数の最適な設定方法は、対象のアプリケーションで実験することです。

### [Alternative linear algebra backends](@id man-backends-linear-algebra)

OpenBLAS の代替として、線形代数の性能向上に役立つバックエンドがいくつかあります。代表例として、[MKL.jl](https://github.com/JuliaLinearAlgebra/MKL.jl) と [AppleAccelerate.jl](https://github.com/JuliaMath/AppleAccelerate.jl) があります。

これらは外部パッケージなので、ここでは詳しく説明しません。各パッケージのドキュメントを参照してください（特に、マルチスレッドに関する動作は OpenBLAS と異なります）。

## Execution latency, package loading and package precompiling time

### Reducing time to first plot etc.

Julia のメソッドは、初めて呼び出されたときにコンパイルされます（そのメソッドが呼び出すメソッドや、静的に特定できるメソッドも同様です）。[`@time`](@ref) マクロ群で、この動作を確認できます。

```
julia> foo() = rand(2,2) * rand(2,2)
foo (generic function with 1 method)

julia> @time @eval foo();
  0.252395 seconds (1.12 M allocations: 56.178 MiB, 2.93% gc time, 98.12% compilation time)

julia> @time @eval foo();
  0.000156 seconds (63 allocations: 2.453 KiB)
```

コンパイル時間の測定には `@time @eval` のほうが適しています。[`@eval`](@ref) を使わないと、計測開始前に一部のコンパイルが済んでいる可能性があるためです。

パッケージを開発する際は、*事前コンパイル*によってユーザーの利用体験を向上できる場合があります。パッケージを使うときに、必要なコードがすでにコンパイルされている状態にできます。パッケージのコードを効果的に事前コンパイルするには、事前コンパイル時に [`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/) を使って、一般的なパッケージの使い方を代表する「事前コンパイル用ワークロード」を実行することを推奨します。これにより、ネイティブのコンパイル済みコードがパッケージの `pkgimage` キャッシュに保存され、その使い方での「初回実行までの時間」（TTFX と呼ばれることが多い）が大幅に短縮されます。

事前コンパイルに余分な時間をかけたくない場合（パッケージの開発中など）は、[`PrecompileTools.jl`](https://julialang.github.io/PrecompileTools.jl/stable/) ワークロードを無効にしたり、Preferences で設定を変更したりできます。

### Reducing package loading time

パッケージの読み込み時間は、通常、短く保つのが望ましいでしょう。パッケージ開発者が心がけるべき一般的な事項は次のとおりです。

1. 本当に必要なものだけに依存関係を絞る。必須の依存関係を増やさずに他のパッケージとの相互運用性を実現するには、[package extensions](@ref man-extensions) の利用を検討してください。
2. 代替手段がない場合を除き、[`__init__()`](@ref) 関数の使用を避ける。特に、大量のコンパイルを引き起こす可能性があるものや、実行に時間がかかるものは避けてください。
3. 可能であれば、依存関係とパッケージコード内の [invalidations](https://julialang.org/blog/2020/08/invalidations/) を固定する。

REPL では、[`@time_imports`](@ref) ツールを使って、上記の要因を確認できます。

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

この例では複数のパッケージが読み込まれています。その一部には `__init__()` 関数があり、コンパイルを引き起こすものもあります。その中には再コンパイルも含まれます。先に読み込まれたパッケージがメソッドを無効化すると、後続のパッケージが `__init__()` 関数を実行する際、コードを実行する前に再コンパイルが発生することがあります。

また、依存関係ツリーに `SparseArrays` が含まれているため、`Statistics` 拡張機能 `SparseArraysExt` が有効になっていることにも注意してください。つまり、`0.4 ms  Statistics → SparseArraysExt` を参照してください。

このレポートは、依存関係の読み込みコストに見合う機能が得られているかを見直すよい機会になります。また、`Pkg` ユーティリティ `why` を使うと、間接依存関係が存在する理由を報告できます。

```
(CustomPackage) pkg> why FFMPEG_jll
  Plots → FFMPEG → FFMPEG_jll
  Plots → GR → GR_jll → FFMPEG_jll
```

または、パッケージが持ち込む間接依存関係を確認するには、パッケージに対して `pkg> rm` を実行し、マニフェストから削除された依存関係を確認してから、`pkg> undo` で変更を元に戻します。

読み込み時間の大部分が、コンパイルを伴う遅い `__init__()` メソッドに費やされている場合、何がコンパイルされているかを調べる方法の1つは、Julia の引数 `--trace-compile=stderr --trace-compile-timing` を使うことです。メソッドがコンパイルされるたびに [`precompile`](@ref) 文が出力され、コンパイルにかかった時間も表示されます。InteractiveUtils の [`@trace_compile`](@ref) マクロを使うと、特定の呼び出しに対してこれらの引数を有効にできます。完全なレポートを得るには、次のように呼び出します。

```
julia> @time @time_imports @trace_compile using CustomPackage
...
```

`--startup-file=no` によって、`startup.jl` にあるパッケージからテストを切り離せることに注意してください。

再コンパイルの原因をさらに詳しく分析するには、[`SnoopCompile`](https://github.com/timholy/SnoopCompile.jl) パッケージを使えます。

### Tracing expression evaluation

テストやスクリプトの実行中に評価されているコードを把握するには、コマンドラインオプション `--trace-eval` またはグローバル制御 [`Base.TRACE_EVAL`](@ref) を使って、評価される最外側の式（トップレベル文）を追跡できます。ただし、関数呼び出しやコードブロックの中身は個別に報告されません。

```bash
# Show only location information during evaluation
julia --trace-eval=loc script.jl

# Show full expressions being evaluated
julia --trace-eval=full script.jl
```

プログラムからも制御できます。

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

パッケージの事前コンパイルに時間がかかる場合は、次の内部設定を行ってから事前コンパイルする方法があります。

```
julia> Base.PRECOMPILE_TRACE_COMPILE[] = "stderr"

pkg> precompile
```

これにより、事前コンパイルの各プロセスで `--trace-compile=stderr --trace-compile-timing` が設定され、どのメソッドが事前コンパイルされたかと、その所要時間が表示されます。

[using the external profiler Tracy to profile the precompilation process](@ref Profiling-package-precompilation-with-Tracy) などのプロファイリングオプションもあります。

## Miscellaneous

### Tweaks

内側のループで役立つ、細かな注意点をいくつか紹介します。

  * 不要な配列を避けてください。たとえば、[`sum([x,y,z])`](@ref) の代わりに `x+y+z` を使います。
  * 複素数の `z` には、[`abs(z)^2`](@ref) ではなく [`abs2(z)`](@ref) を使います。一般に、複雑な引数を扱うコードは、[`abs`](@ref) ではなく [`abs2`](@ref) を使うよう書き換えてください。
  * 整数の切り捨て除算には [`trunc(x/y)`](@ref) ではなく [`div(x,y)`](@ref) を使い、[`floor(x/y)`](@ref) ではなく [`fld(x,y)`](@ref) を、[`ceil(x/y)`](@ref) ではなく [`cld(x,y)`](@ref) を使います。

### Fix deprecation warnings

非推奨関数は、関連する警告を一度だけ表示するために、内部で検索を行います。この追加の検索によって大幅に遅くなることがあるため、警告で示された方法に従って、非推奨関数の使用箇所をすべて修正してください。

### [Performance Annotations](@id man-performance-annotations)

プログラムの特定の性質を保証することで、より強い最適化を有効にできる場合があります。

  * [`@inbounds`](@ref) を使うと、式内の配列境界チェックを省略できます。実行前に必ず確認してください。インデックスが範囲外になると、クラッシュや気付かないデータ破損が起きる可能性があります。
  * [`@fastmath`](@ref) を使うと、実数では正しいものの IEEE 数値では結果に差が生じる浮動小数点最適化を許可できます。数値結果が変わる可能性があるため、使用には注意してください。これは clang の `-ffast-math` オプションに相当します。
  * `for` ループの前に [`@simd`](@ref) を書くと、反復が互いに独立しており、順序を変更できることを保証できます。多くの場合、Julia は `@simd` マクロなしでもコードを自動的にベクトル化できるため、このマクロが有効なのは、そうした変換が通常は許されない場合に限られます。たとえば、浮動小数点演算の結合順序を変えたり、依存するメモリアクセス（`@simd ivdep`）を無視したりする場合です。`@simd` を指定する際は、十分注意してください。反復間に依存関係があるループに誤って注釈を付けると、予期しない結果になる可能性があります。特に、一部の `AbstractArray` サブタイプに対する `setindex!` は、反復順序に本質的に依存することに注意してください。**この機能は実験的なものであり、今後の Julia のバージョンで変更または削除される可能性があります。**

AbstractArray のインデックスに 1:n を使う一般的な書き方は、配列が通常とは異なるインデックスを使う場合には安全ではありません。また、境界チェックを無効にするとセグメンテーション違反が起きる可能性があります。代わりに `LinearIndices(x)` または `eachindex(x)` を使ってください（[Arrays with custom indices](@ref man-custom-indices) も参照）。

!!! note
    `@simd` は最内側の `for` ループの直前に置く必要があります。一方、`@inbounds` と `@fastmath` は、単一の式にも、入れ子になったコードブロック内のすべての式にも適用できます。たとえば、`@inbounds begin` や `@inbounds for ...` を使います。


`@inbounds` と `@simd` の両方で注釈を付けた例を示します（ベンチマークを最適化しすぎないよう、ここでは `@noinline` を使っています）。

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

2.4 GHz の Intel Core i5 プロセッサを搭載したコンピュータでは、次の結果になります。

```
GFlop/sec        = 1.9467069505224963
GFlop/sec (SIMD) = 17.578554163920018
```

（`GFlop/sec` は性能を測定するもので、数値が大きいほど高速です。）

3種類すべての注釈を使った例を示します。このプログラムは、まず1次元配列の有限差分を計算し、次にその結果の L2 ノルムを求めます。

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

2.7 GHz の Intel Core i7 プロセッサを搭載したコンピュータでは、次の結果になります。

```
$ julia wave.jl;
  1.207814709 seconds
4.443986180758249

$ julia --math-mode=ieee wave.jl;
  4.487083643 seconds
4.443986180758249
```

ここでは `--math-mode=ieee` オプションによって `@fastmath` マクロを無効にし、結果を比較できるようにしています。

この例では、`@fastmath` による高速化は約3.7倍です。これは非常に大きな値で、一般には高速化の幅はもっと小さくなります。（この例では、ベンチマークのワーキングセットがプロセッサの L1 キャッシュに収まるため、メモリアクセスの遅延は影響せず、計算時間は CPU の使用量に左右されます。実際のプログラムでは、そうならないことが多いでしょう。）また、この例では最適化によって結果は変わりませんが、一般には結果がわずかに異なります。数値的に不安定なアルゴリズムなどでは、結果が大きく異なる場合もあります。

`@fastmath` 注釈は、評価順序を変えるなどして浮動小数点式を並べ替えたり、特定の特殊値（inf、nan）が発生しないと仮定したりします。この例（およびこの特定のコンピュータ）では、主な違いは、関数 `deriv` 内の式 `1 / (2*dx)` がループの外に移動されることです（つまり、ループの外で計算されます）。これは、`idx = 1 / (2*dx)` と書いた場合と同じです。ループ内の式 `... / (2*dx)` は `... * idx` となり、評価が大幅に速くなります。もちろん、コンパイラが実際に適用する最適化も、それによる高速化も、ハードウェアに大きく依存します。Julia の [`code_native`](@ref) 関数を使うと、生成コードの変化を調べられます。

`@fastmath` は、計算中に `NaN` が発生しないことも仮定します。そのため、次のような予想外の動作が起きることがあります。

```jldoctest
julia> f(x) = isnan(x);

julia> f(NaN)
true

julia> f_fast(x) = @fastmath isnan(x);

julia> f_fast(NaN)
false
```

### Treat Subnormal Numbers as Zeros

サブノーマル数（以前は [denormal numbers](https://en.wikipedia.org/wiki/Denormal_number) と呼ばれていました）は多くの場面で役立ちますが、ハードウェアによっては性能低下を招きます。[`set_zero_subnormals(true)`](@ref) を呼び出すと、浮動小数点演算でサブノーマルな入力や出力をゼロとして扱うことが許可され、ハードウェアによっては性能が向上します。[`set_zero_subnormals(false)`](@ref) を呼び出すと、サブノーマル数に対して厳密な IEEE 動作が強制されます。

以下は、ハードウェアによってサブノーマル数が性能に明確な影響を与える例です。

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

次のような出力になります。

```
  0.002202 seconds (1 allocation: 4.063 KiB)
  0.001502 seconds (1 allocation: 4.063 KiB)
  0.002139 seconds (1 allocation: 4.063 KiB)
  0.001454 seconds (1 allocation: 4.063 KiB)
  0.002115 seconds (1 allocation: 4.063 KiB)
  0.001455 seconds (1 allocation: 4.063 KiB)
```

偶数回目の反復が大幅に速いことに注目してください。

この例では、`a` の値が指数関数的に減少する曲線となり、時間とともにゆっくり平坦化するため、多数のサブノーマル数が生成されます。

サブノーマル数をゼロとして扱うと、`x-y == 0` ならば `x == y` といった恒等式が成り立たなくなるため、注意して使ってください。

```jldoctest
julia> x = 3f-38; y = 2f-38;

julia> set_zero_subnormals(true); (x - y, x == y)
(0.0f0, false)

julia> set_zero_subnormals(false); (x - y, x == y)
(1.0000001f-38, false)
```

アプリケーションによっては、サブノーマル数をゼロにする代わりに、ごく小さなノイズを加える方法もあります。たとえば、`a` をゼロで初期化する代わりに、次のように初期化します。

```julia
a = rand(Float32,1000) * 1.f-9
```

### Avoid string interpolation for I/O

ファイル（またはその他の I/O デバイス）にデータを書き込む際、余分な中間文字列を作るとオーバーヘッドが発生します。次のようにする代わりに、

```julia
println(file, "$a $b")
```

次のようにします。

```julia
println(file, a, " ", b)
```

最初のコードでは文字列を作成してからファイルに書き込みますが、2つ目のコードでは値を直接ファイルに書き込みます。また、場合によっては文字列補間のほうが読みにくくなることにも注意してください。次を考えてみましょう。

```julia
println(file, "$(f(a))$(f(b))")
```

こちらと、

```julia
println(file, f(a), f(b))
```

### Avoid eager string materialization

エラー処理や非推奨機能に関する条件付き警告など、オブジェクトの文字列表現が条件付きでしか必要ない場合は、文字列を先に生成するオーバーヘッドを避けるのが望ましいでしょう。Julia 1.8 以降では、[`LazyString`](@ref) と、それに対応する文字列マクロ [`@lazy_str`](@ref) を使って実現できます。

たとえば、次のようにする代わりに、

```julia
Base.depwarn("`foo` is deprecated for type $(typeof(x))", :bar)
```

次のようにします。

```julia
Base.depwarn(lazy"`foo` is deprecated for type $(typeof(x))", :bar)
```

または、マクロを使わずに同等の処理を行います。

```julia
Base.depwarn(LazyString("`foo` is deprecated for type ", typeof(x)), :bar)
```

この方法では、補間された文字列は実際に表示されるときにだけ作成されます。

### Optimize network I/O during parallel execution

リモート関数を並列実行する場合、

```julia
using Distributed

responses = Vector{Any}(undef, nworkers())
@sync begin
    for (idx, pid) in enumerate(workers())
        Threads.@spawn responses[idx] = remotecall_fetch(foo, pid, args...)
    end
end
```

こちらのほうが次より高速です。

```julia
using Distributed

refs = Vector{Any}(undef, nworkers())
for (idx, pid) in enumerate(workers())
    refs[idx] = @spawnat pid foo(args...)
end
responses = [fetch(r) for r in refs]
```

前者では各ワーカーとのネットワーク往復が1回で済みますが、後者ではネットワーク呼び出しが2回発生します。1回目は [`@spawnat`](@ref) によるもので、2回目は [`fetch`](@ref)（場合によっては [`wait`](@ref)）によるものです。また、[`fetch`](@ref)/[`wait`](@ref) は逐次実行されるため、全体の性能も低下します。

### [Use `MutableArithmetics` for more control over allocation for mutable arithmetic types](@id man-perftips-mutablearithmetics)

[`Number`](@ref) のサブタイプの中には、[`BigInt`](@ref) や [`BigFloat`](@ref) のように、[`mutable struct`](@ref) 型として実装されていたり、ミュータブルな要素を含んでいたりするものがあります。このような場合、Julia の算術インターフェース `Base` は効率より使いやすさを優先することが多いため、単純に使うと性能が最適でない場合があります。一方、[`MutableArithmetics`](https://juliahub.com/ui/Packages/General/MutableArithmetics) パッケージの抽象化を使うと、こうした型のミュータブル性を活用し、必要最小限の割り当てで高速なコードを書けます。また、`MutableArithmetics` を使えば、必要に応じてミュータブルな算術型の値を明示的にコピーできます。`MutableArithmetics` はユーザーパッケージであり、Julia プロジェクトとは関係ありません。

# [Single- and multi-dimensional Arrays](@id man-multi-dim-arrays)

Juliaは、ほとんどの技術計算言語と同様に、第一級の配列実装を提供しています。ほとんどの技術計算言語は、他のコンテナを犠牲にして配列実装に多くの注意を払っていますが、Juliaは配列を特別な方法で扱いません。配列ライブラリはほぼ完全にJulia自体で実装されており、他のJuliaで書かれたコードと同様にコンパイラからパフォーマンスを引き出します。そのため、[`AbstractArray`](@ref)から継承することでカスタム配列タイプを定義することも可能です。カスタム配列タイプの実装に関する詳細は、[manual section on the AbstractArray interface](@ref man-interface-array)を参照してください。

配列は、多次元グリッドに格納されたオブジェクトのコレクションです。ゼロ次元配列は許可されています。[this FAQ entry](@ref faq-array-0dim)を参照してください。最も一般的な場合、配列には[`Any`](@ref)型のオブジェクトが含まれる可能性があります。ほとんどの計算目的では、配列には[`Float64`](@ref)や[`Int32`](@ref)のような、より特定の型のオブジェクトを含めるべきです。

一般的に、他の多くの技術計算言語とは異なり、Juliaはパフォーマンスのためにプログラムがベクトル化スタイルで書かれることを期待していません。Juliaのコンパイラは型推論を使用し、スカラー配列インデックスのために最適化されたコードを生成します。これにより、プログラムは便利で読みやすいスタイルで書かれ、パフォーマンスを犠牲にすることなく、時にはメモリを少なく使用することができます。

Juliaでは、関数へのすべての引数は[passed by sharing](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_sharing)（すなわちポインタによって）渡されます。一部の技術計算言語では配列を値渡ししますが、これは呼び出し元の値を呼び出し先が誤って変更するのを防ぎますが、配列の不要なコピーを避けるのが難しくなります。慣例として、`!`で終わる関数名は、1つ以上の引数の値を変更または破壊することを示します（例えば、[`sort`](@ref)と[`sort!`](@ref)を比較してください）。呼び出し先は、変更したくない入力を変更しないようにするために明示的なコピーを作成する必要があります。多くの非変異関数は、入力の明示的なコピーに対して末尾に`!`を追加した同名の関数を呼び出すことで実装され、そのコピーを返します。

## Basic Functions

| Function               | Description                                                                      |
|:---------------------- |:-------------------------------------------------------------------------------- |
| [`eltype(A)`](@ref)    | the type of the elements contained in `A`                                        |
| [`length(A)`](@ref)    | the number of elements in `A`                                                    |
| [`ndims(A)`](@ref)     | the number of dimensions of `A`                                                  |
| [`size(A)`](@ref)      | a tuple containing the dimensions of `A`                                         |
| [`size(A,n)`](@ref)    | the size of `A` along dimension `n`                                              |
| [`axes(A)`](@ref)      | a tuple containing the valid indices of `A`                                      |
| [`axes(A,n)`](@ref)    | a range expressing the valid indices along dimension `n`                         |
| [`eachindex(A)`](@ref) | an efficient iterator for visiting each position in `A`                          |
| [`stride(A,k)`](@ref)  | the stride (linear index distance between adjacent elements) along dimension `k` |
| [`strides(A)`](@ref)   | a tuple of the strides in each dimension                                         |

## Construction and Initialization

多くの配列を構築および初期化するための関数が提供されています。以下の関数のリストでは、`dims...` 引数を持つ呼び出しは、次元サイズの単一のタプルを受け取るか、可変数の引数として次元サイズの一連を受け取ることができます。これらの関数のほとんどは、配列の要素タイプである最初の入力 `T` も受け入れます。タイプ `T` が省略された場合、デフォルトで [`Float64`](@ref) になります。

| Function                           | Description                                                                                                                                                                                                                                  |
|:---------------------------------- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`Array{T}(undef, dims...)`](@ref) | an uninitialized dense [`Array`](@ref)                                                                                                                                                                                                       |
| [`zeros(T, dims...)`](@ref)        | an `Array` of all zeros                                                                                                                                                                                                                      |
| [`ones(T, dims...)`](@ref)         | an `Array` of all ones                                                                                                                                                                                                                       |
| [`trues(dims...)`](@ref)           | a [`BitArray`](@ref) with all values `true`                                                                                                                                                                                                  |
| [`falses(dims...)`](@ref)          | a `BitArray` with all values `false`                                                                                                                                                                                                         |
| [`reshape(A, dims...)`](@ref)      | an array containing the same data as `A`, but with different dimensions                                                                                                                                                                      |
| [`copy(A)`](@ref)                  | copy `A`                                                                                                                                                                                                                                     |
| [`deepcopy(A)`](@ref)              | copy `A`, recursively copying its elements                                                                                                                                                                                                   |
| [`similar(A, T, dims...)`](@ref)   | an uninitialized array of the same type as `A` (dense, sparse, etc.), but with the specified element type and dimensions. The second and third arguments are both optional, defaulting to the element type and dimensions of `A` if omitted. |
| [`reinterpret(T, A)`](@ref)        | an array with the same binary data as `A`, but with element type `T`                                                                                                                                                                         |
| [`rand(T, dims...)`](@ref)         | an `Array` with random, iid [^1] and uniformly distributed values. For floating point types `T`, the values lie in the half-open interval $[0, 1)$.                                                                                          |
| [`randn(T, dims...)`](@ref)        | an `Array` with random, iid and standard normally distributed values                                                                                                                                                                         |
| [`Matrix{T}(I, m, n)`](@ref)       | `m`-by-`n` identity matrix. Requires `using LinearAlgebra` for [`I`](@ref).                                                                                                                                                                  |
| [`range(start, stop, n)`](@ref)    | a range of `n` linearly spaced elements from `start` to `stop`                                                                                                                                                                               |
| [`fill!(A, x)`](@ref)              | fill the array `A` with the value `x`                                                                                                                                                                                                        |
| [`fill(x, dims...)`](@ref)         | an `Array` filled with the value `x`. In particular, `fill(x)` constructs a zero-dimensional `Array` containing `x`.                                                                                                                         |

[^1]: *iid*, independently and identically distributed.

これらの関数に次元を渡すさまざまな方法を見るために、次の例を考えてみましょう：

```jldoctest
julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros(Int8, (2, 3))
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros((2, 3))
2×3 Matrix{Float64}:
 0.0  0.0  0.0
 0.0  0.0  0.0
```

ここで、`(2, 3)` は [`Tuple`](@ref) であり、最初の引数 — 要素タイプ — はオプションで、デフォルトは `Float64` です。

## [Array literals](@id man-array-literals)

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]` creates a one-dimensional array (i.e., a vector) containing the comma-separated arguments as its elements. The element type ([`eltype`](@ref)) of the resulting array is automatically determined by the types of the arguments inside the braces. If all the arguments are the same type, then that is its `eltype`. If they all have a common [promotion type](@ref conversion-and-promotion) then they get converted to that type using [`convert`](@ref) and that type is the array's `eltype`. Otherwise, a heterogeneous array that can hold anything — a `Vector{Any}` — is constructed; this includes the literal `[]` where no arguments are given. [Array literal can be typed](@ref man-array-typed-literal) with the syntax `T[A, B, C, ...]` where `T` is a type.

```jldoctest
julia> [1, 2, 3] # An array of `Int`s
3-element Vector{Int64}:
 1
 2
 3

julia> promote(1, 2.3, 4//5) # This combination of Int, Float64 and Rational promotes to Float64
(1.0, 2.3, 0.8)

julia> [1, 2.3, 4//5] # Thus that's the element type of this Array
3-element Vector{Float64}:
 1.0
 2.3
 0.8

julia> Float32[1, 2.3, 4//5] # Specify element type manually
3-element Vector{Float32}:
 1.0
 2.3
 0.8

julia> []
Any[]
```

### [Concatenation](@id man-array-concatenation)

もし角括弧内の引数がカンマの代わりにセミコロン（`;`）や改行で区切られている場合、それらの内容は*縦に連結*されるため、引数自体が要素として使用されるのではありません。

```jldoctest
julia> [1:2, 4:5] # Has a comma, so no concatenation occurs. The ranges are themselves the elements
2-element Vector{UnitRange{Int64}}:
 1:2
 4:5

julia> [1:2; 4:5]
4-element Vector{Int64}:
 1
 2
 4
 5

julia> [1:2
        4:5
        6]
5-element Vector{Int64}:
 1
 2
 4
 5
 6
```

同様に、引数がタブやスペース、または二重セミコロンで区切られている場合、その内容は*水平方向に連結*されます。

```jldoctest
julia> [1:2  4:5  7:8]
2×3 Matrix{Int64}:
 1  4  7
 2  5  8

julia> [[1,2]  [4,5]  [7,8]]
2×3 Matrix{Int64}:
 1  4  7
 2  5  8

julia> [1 2 3] # Numbers can also be horizontally concatenated
1×3 Matrix{Int64}:
 1  2  3

julia> [1;; 2;; 3;; 4]
1×4 Matrix{Int64}:
 1  2  3  4
```

単一のセミコロン（または改行）とスペース（またはタブ）を組み合わせることで、同時に水平方向と垂直方向の両方で連結することができます。

```jldoctest
julia> [1 2
        3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> [zeros(Int, 2, 2) [1; 2]
        [3 4]            5]
3×3 Matrix{Int64}:
 0  0  1
 0  0  2
 3  4  5

julia> [[1 1]; 2 3; [4 4]]
3×2 Matrix{Int64}:
 1  1
 2  3
 4  4
```

スペース（およびタブ）はセミコロンよりも優先度が高く、最初に水平方向の連結を行い、その後に結果を連結します。一方、水平連結のためにダブルセミコロンを使用すると、結果を水平方向に連結する前に垂直方向の連結が行われます。

```jldoctest
julia> [zeros(Int, 2, 2) ; [3 4] ;; [1; 2] ; 5]
3×3 Matrix{Int64}:
 0  0  1
 0  0  2
 3  4  5

julia> [1:2; 4;; 1; 3:4]
3×2 Matrix{Int64}:
 1  1
 2  3
 4  4
```

`；` と `;;` が第一および第二次元で連結されるのと同様に、より多くのセミコロンを使用することでこの一般的なスキームが拡張されます。区切りのセミコロンの数は特定の次元を指定し、`;;;` は第三次元で連結し、`;;;;` は第四次元で連結します。セミコロンが少ない方が優先されるため、一般的に低次元が最初に連結されます。

```jldoctest
julia> [1; 2;; 3; 4;; 5; 6;;;
        7; 8;; 9; 10;; 11; 12]
2×3×2 Array{Int64, 3}:
[:, :, 1] =
 1  3  5
 2  4  6

[:, :, 2] =
 7   9  11
 8  10  12
```

以前と同様に、水平連結のためのスペース（およびタブ）は、任意の数のセミコロンよりも優先されます。したがって、高次元配列も、行を最初に指定し、その要素をレイアウトに似た方法でテキスト的に配置することによって記述できます。

```jldoctest
julia> [1 3 5
        2 4 6;;;
        7 9 11
        8 10 12]
2×3×2 Array{Int64, 3}:
[:, :, 1] =
 1  3  5
 2  4  6

[:, :, 2] =
 7   9  11
 8  10  12

julia> [1 2;;; 3 4;;;; 5 6;;; 7 8]
1×2×2×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  2

[:, :, 2, 1] =
 3  4

[:, :, 1, 2] =
 5  6

[:, :, 2, 2] =
 7  8

julia> [[1 2;;; 3 4];;;; [5 6];;; [7 8]]
1×2×2×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  2

[:, :, 2, 1] =
 3  4

[:, :, 1, 2] =
 5  6

[:, :, 2, 2] =
 7  8
```

二次元での連結を意味するにもかかわらず、スペース（またはタブ）と `;;` は、ダブルセミコロンが単に「行継続」文字として機能している場合を除いて、同じ配列式に現れることはできません。これにより、単一の水平連結が複数行にわたって展開されることが可能になり（行の改行が垂直連結として解釈されることはありません）。

```jldoctest
julia> [1 2 ;;
       3 4]
1×4 Matrix{Int64}:
 1  2  3  4
```

セミコロンを終了させることで、長さ1の次元を追加することもできます。

```jldoctest
julia> [1;;]
1×1 Matrix{Int64}:
 1

julia> [2; 3;;;]
2×1×1 Array{Int64, 3}:
[:, :, 1] =
 2
 3
```

より一般的には、連結は [`cat`](@ref) 関数を通じて実行できます。これらの構文は、便利な関数である関数呼び出しの省略形です：

| Syntax                 | Function         | Description                                                                                                |
|:---------------------- |:---------------- |:---------------------------------------------------------------------------------------------------------- |
|                        | [`cat`](@ref)    | concatenate input arrays along dimension(s) `k`                                                            |
| `[A; B; C; ...]`       | [`vcat`](@ref)   | shorthand for `cat(A...; dims=1)`                                                                          |
| `[A B C ...]`          | [`hcat`](@ref)   | shorthand for `cat(A...; dims=2)`                                                                          |
| `[A B; C D; ...]`      | [`hvcat`](@ref)  | simultaneous vertical and horizontal concatenation                                                         |
| `[A; C;; B; D;;; ...]` | [`hvncat`](@ref) | simultaneous n-dimensional concatenation, where number of semicolons indicate the dimension to concatenate |

### [Typed array literals](@id man-array-typed-literal)

特定の要素型を持つ配列は、構文 `T[A, B, C, ...]` を使用して構築できます。これにより、要素型 `T` の1次元配列が構築され、要素 `A`、`B`、`C` などで初期化されます。たとえば、`Any[x, y, z]` は、任意の値を含むことができる異種配列を構築します。

連結構文は、結果の要素タイプを指定するために、同様にタイプでプレフィックスを付けることができます。

```jldoctest
julia> [[1 2] [3 4]]
1×4 Matrix{Int64}:
 1  2  3  4

julia> Int8[[1 2] [3 4]]
1×4 Matrix{Int8}:
 1  2  3  4
```

## [Comprehensions](@id man-comprehensions)

包括は、配列を構築するための一般的で強力な方法を提供します。包括の構文は、数学における集合構築記法に似ています：

```
A = [ F(x, y, ...) for x=rx, y=ry, ... ]
```

この形式の意味は、`F(x,y,...)`が変数`x`、`y`などが与えられた値のリストの各値を取ることで評価されるということです。値は任意の反復可能なオブジェクトとして指定できますが、一般的には`1:n`や`2:(n-1)`のような範囲や、`[1.2, 3.4, 5.7]`のような明示的な値の配列が使われます。結果は、変数範囲`rx`、`ry`などの次元の連結からなるN次元の密な配列であり、各`F(x,y,...)`の評価はスカラーを返します。

次の例は、1次元グリッドに沿った現在の要素とその左隣および右隣の隣接要素の加重平均を計算します。

```julia-repl
julia> x = rand(8)
8-element Array{Float64,1}:
 0.843025
 0.869052
 0.365105
 0.699456
 0.977653
 0.994953
 0.41084
 0.809411

julia> [ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
6-element Array{Float64,1}:
 0.736559
 0.57468
 0.685417
 0.912429
 0.8446
 0.656511
```

結果の配列の型は、計算された要素の型に依存します。これは [array literals](@ref man-array-literals) のように動作します。型を明示的に制御するために、型を内包表記の前に追加することができます。たとえば、単精度で結果を要求するには、次のように記述できます：

```julia
Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
```

## [Generator Expressions](@id man-generators)

内包表記は、囲む角括弧なしで書くこともでき、ジェネレーターと呼ばれるオブジェクトを生成します。このオブジェクトは、事前に配列を割り当てて値を保存するのではなく、必要に応じて値を生成するために反復処理できます（[Iteration](@ref)を参照）。例えば、以下の式はメモリを割り当てることなく一連の合計を計算します：

```jldoctest
julia> sum(1/n^2 for n=1:1000)
1.6439345666815615
```

引数リスト内で複数の次元を持つジェネレーター式を書くときは、ジェネレーターを後続の引数から分けるために括弧が必要です：

```julia-repl
julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
ERROR: syntax: invalid iteration specification
```

`for`の後のカンマ区切りの式はすべて範囲として解釈されます。括弧を追加することで、[`map`](@ref)に第3の引数を追加できます:

```jldoctest
julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
2×2 Matrix{Tuple{Float64, Int64}}:
 (0.5, 1)       (0.333333, 3)
 (0.333333, 2)  (0.25, 4)
```

ジェネレーターは内部関数を介して実装されます。言語の他の場所で使用される内部関数と同様に、外部スコープの変数は内部関数で「キャプチャ」されることがあります。たとえば、`sum(p[i] - q[i] for i=1:n)`は、外部スコープから3つの変数`p`、`q`、`n`をキャプチャします。キャプチャされた変数はパフォーマンスの課題を引き起こす可能性があります。詳細は[performance tips](@ref man-performance-captured)を参照してください。

ジェネレーターや内包表記の範囲は、複数の `for` キーワードを書くことで前の範囲に依存することができます:

```jldoctest
julia> [(i, j) for i=1:3 for j=1:i]
6-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (2, 1)
 (2, 2)
 (3, 1)
 (3, 2)
 (3, 3)
```

そのような場合、結果は常に1-dです。

生成された値は `if` キーワードを使用してフィルタリングできます:

```jldoctest
julia> [(i, j) for i=1:3 for j=1:i if i+j == 4]
2-element Vector{Tuple{Int64, Int64}}:
 (2, 2)
 (3, 1)
```

## [Indexing](@id man-array-indexing)

n次元配列 `A` にインデックスを付ける一般的な構文は次のとおりです：

```
X = A[I_1, I_2, ..., I_n]
```

各 `I_k` はスカラー整数、整数の配列、またはその他の [supported index](@ref man-supported-index-types) である可能性があります。これには、全次元内のすべてのインデックスを選択するための [`Colon`](@ref) (`:`)、連続またはストライドされたサブセクションを選択するための形式 `a:c` または `a:b:c`、および `true` インデックスで要素を選択するためのブール値の配列が含まれます。

すべてのインデックスがスカラーである場合、結果 `X` は配列 `A` の単一の要素です。それ以外の場合、`X` はすべてのインデックスの次元数の合計と同じ次元数を持つ配列です。

すべてのインデックス `I_k` がベクトルである場合、`X` の形状は `(length(I_1), length(I_2), ..., length(I_n))` となり、`X` の位置 `i_1, i_2, ..., i_n` には値 `A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]` が含まれます。

例:

```jldoctest
julia> A = reshape(collect(1:16), (2, 2, 2, 2))
2×2×2×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  3
 2  4

[:, :, 2, 1] =
 5  7
 6  8

[:, :, 1, 2] =
  9  11
 10  12

[:, :, 2, 2] =
 13  15
 14  16

julia> A[1, 2, 1, 1] # all scalar indices
3

julia> A[[1, 2], [1], [1, 2], [1]] # all vector indices
2×1×2×1 Array{Int64, 4}:
[:, :, 1, 1] =
 1
 2

[:, :, 2, 1] =
 5
 6

julia> A[[1, 2], [1], [1, 2], 1] # a mix of index types
2×1×2 Array{Int64, 3}:
[:, :, 1] =
 1
 2

[:, :, 2] =
 5
 6
```

最後の2つのケースで、結果の配列のサイズが異なることに注意してください。

`I_1`が二次元行列に変更されると、`X`は形状が`(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))`の`n+1`次元配列になります。この行列は次元を追加します。

例:

```jldoctest
julia> A = reshape(collect(1:16), (2, 2, 2, 2));

julia> A[[1 2; 1 2]]
2×2 Matrix{Int64}:
 1  2
 1  2

julia> A[[1 2; 1 2], 1, 2, 1]
2×2 Matrix{Int64}:
 5  6
 5  6
```

位置 `i_1, i_2, i_3, ..., i_{n+1}` には `A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]` の値が含まれています。スカラーでインデックス付けされたすべての次元は削除されます。たとえば、`J` がインデックスの配列である場合、`A[2, J, 3]` の結果は `size(J)` のサイズを持つ配列です。その `j` 番目の要素は `A[2, J[j], 3]` によって埋められます。

この構文の特別な部分として、`end`キーワードは、インデックス付けブラケット内の各次元の最後のインデックスを表すために使用される場合があります。これは、インデックス付けされる最も内側の配列のサイズによって決まります。`end`キーワードなしのインデックス付け構文は、[`getindex`](@ref)への呼び出しと同等です。

```
X = getindex(A, I_1, I_2, ..., I_n)
```

例:

```jldoctest
julia> x = reshape(1:16, 4, 4)
4×4 reshape(::UnitRange{Int64}, 4, 4) with eltype Int64:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> x[2:3, 2:end-1]
2×2 Matrix{Int64}:
 6  10
 7  11

julia> x[1, [2 3; 4 1]]
2×2 Matrix{Int64}:
  5  9
 13  1
```

## [Indexed Assignment](@id man-indexed-assignment)

n次元配列 `A` に値を割り当てる一般的な構文は次のとおりです：

```
A[I_1, I_2, ..., I_n] = X
```

各 `I_k` はスカラー整数、整数の配列、またはその他の [supported index](@ref man-supported-index-types) である可能性があります。これには、全次元内のすべてのインデックスを選択するための [`Colon`](@ref) (`:`)、連続したまたはストライドされたサブセクションを選択するための形式 `a:c` または `a:b:c`、および `true` インデックスで要素を選択するためのブール値の配列が含まれます。

If all indices `I_k` are integers, then the value in location `I_1, I_2, ..., I_n` of `A` is overwritten with the value of `X`, [`convert`](@ref)ing to the [`eltype`](@ref) of `A` if necessary.

If any index `I_k` is itself an array, then the right hand side `X` must also be an array with the same shape as the result of indexing `A[I_1, I_2, ..., I_n]` or a vector with the same number of elements. The value in location `I_1[i_1], I_2[i_2], ..., I_n[i_n]` of `A` is overwritten with the value `X[i_1, i_2, ..., i_n]`, converting if necessary. The element-wise assignment operator `.=` may be used to [broadcast](@ref Broadcasting) `X` across the selected locations:

```
A[I_1, I_2, ..., I_n] .= X
```

[Indexing](@ref man-array-indexing)と同様に、`end`キーワードは、割り当てられる配列のサイズによって決定される各次元の最後のインデックスをインデックス指定のブラケット内で表すために使用される場合があります。`end`キーワードなしのインデックス付き割り当て構文は、[`setindex!`](@ref)への呼び出しと同等です。

```
setindex!(A, X, I_1, I_2, ..., I_n)
```

例:

```jldoctest
julia> x = collect(reshape(1:9, 3, 3))
3×3 Matrix{Int64}:
 1  4  7
 2  5  8
 3  6  9

julia> x[3, 3] = -9;

julia> x[1:2, 1:2] = [-1 -4; -2 -5];

julia> x
3×3 Matrix{Int64}:
 -1  -4   7
 -2  -5   8
  3   6  -9
```

## [Supported index types](@id man-supported-index-types)

式 `A[I_1, I_2, ..., I_n]` において、各 `I_k` はスカラーインデックス、スカラーインデックスの配列、またはスカラーインデックスの配列を表し、[`to_indices`](@ref) によってそのように変換できるオブジェクトである可能性があります。

1. スカラーインデックス。デフォルトでは、これには以下が含まれます：

      * 非ブール整数
      * [`CartesianIndex{N}`](@ref)は、複数の次元にまたがる整数の`N`-タプルのように振る舞います（詳細は以下を参照）。
2. スカラーインデックスの配列。これには次が含まれます：

      * 整数のベクトルと多次元配列
      * 空の配列 `[]` は、要素を選択しないもので、例えば `A[[]]` のようになります（`A[]` と混同しないでください）。
      * `a:c` または `a:b:c` のような範囲は、`a` から `c` までの連続したまたはストライドされた部分を選択します（含む）。
      * `AbstractArray`のサブタイプである任意のカスタムスカラーインデックスの配列
      * `CartesianIndex{N}`の配列（詳細は以下を参照）
3. オブジェクトはスカラーインデックスの配列を表し、[`to_indices`](@ref)によってそのように変換できます。デフォルトでは、これには次が含まれます：

      * [`Colon()`](@ref)（`:`）、これは全次元内または配列全体にわたるすべてのインデックスを表します。
      * ブール値の配列は、`true` インデックスで要素を選択します（詳細は以下を参照）。

いくつかの例:

```jldoctest
julia> A = reshape(collect(1:2:18), (3, 3))
3×3 Matrix{Int64}:
 1   7  13
 3   9  15
 5  11  17

julia> A[4]
7

julia> A[[2, 5, 8]]
3-element Vector{Int64}:
  3
  9
 15

julia> A[[1 4; 3 8]]
2×2 Matrix{Int64}:
 1   7
 5  15

julia> A[[]]
Int64[]

julia> A[1:2:5]
3-element Vector{Int64}:
 1
 5
 9

julia> A[2, :]
3-element Vector{Int64}:
  3
  9
 15

julia> A[:, 3]
3-element Vector{Int64}:
 13
 15
 17

julia> A[:, 3:3]
3×1 Matrix{Int64}:
 13
 15
 17
```

### Cartesian indices

特別な `CartesianIndex{N}` オブジェクトは、複数の次元にまたがる整数の `N` タプルのように振る舞うスカラーインデックスを表します。 例えば：

```jldoctest cartesianindex
julia> A = reshape(1:32, 4, 4, 2);

julia> A[3, 2, 1]
7

julia> A[CartesianIndex(3, 2, 1)] == A[3, 2, 1] == 7
true
```

単独で考えると、これは比較的些細なことに思えるかもしれませんが；`CartesianIndex`は単一の多次元インデックスを表すオブジェクトに複数の整数をまとめるだけです。しかし、他のインデックス形式や`CartesianIndex`を生成するイテレータと組み合わせると、非常にエレガントで効率的なコードを生み出すことができます。以下の[Iteration](@ref)を参照してください。また、より高度な例については、[this blog post on multidimensional algorithms and iteration](https://julialang.org/blog/2016/02/iteration)を参照してください。

`CartesianIndex{N}`の配列もサポートされています。これは、各スカラーインデックスが`N`次元にわたるコレクションを表し、時には点ごとのインデックス付けと呼ばれる形式のインデックス付けを可能にします。たとえば、上から見た`A`の最初の「ページ」から対角要素にアクセスすることを可能にします：

```jldoctest cartesianindex
julia> page = A[:, :, 1]
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> page[[CartesianIndex(1, 1),
             CartesianIndex(2, 2),
             CartesianIndex(3, 3),
             CartesianIndex(4, 4)]]
4-element Vector{Int64}:
  1
  6
 11
 16
```

これは、[dot broadcasting](@ref man-vectorized)を使用し、通常の整数インデックスと組み合わせることで、より簡潔に表現できます（`A`から最初の`page`を別のステップで抽出するのではなく）。さらに、`:`と組み合わせることで、同時に2つのページから両方の対角線を抽出することもできます：

```jldoctest cartesianindex
julia> A[CartesianIndex.(axes(A, 1), axes(A, 2)), 1]
4-element Vector{Int64}:
  1
  6
 11
 16

julia> A[CartesianIndex.(axes(A, 1), axes(A, 2)), :]
4×2 Matrix{Int64}:
  1  17
  6  22
 11  27
 16  32
```

!!! warning
    `CartesianIndex` と `CartesianIndex` の配列は、次元の最後のインデックスを表すために `end` キーワードと互換性がありません。`CartesianIndex` またはその配列を含む可能性のあるインデックス式では `end` を使用しないでください。


### Logical indexing

しばしば論理インデクシングまたは論理マスクによるインデクシングと呼ばれる、ブール配列によるインデクシングは、その値が `true` であるインデックスの要素を選択します。ブールベクトル `B` によるインデクシングは、実際には [`findall(B)`](@ref) によって返される整数のベクトルによるインデクシングと同じです。同様に、`N` 次元のブール配列によるインデクシングは、その値が `true` である `CartesianIndex{N}` のベクトルによるインデクシングと実質的に同じです。論理インデックスは、インデクシングされる次元と同じ形状の配列でなければならず、または提供される唯一のインデックスであり、インデクシングされる配列の一次元に再形成されたビューの形状と一致しなければなりません。一般的に、最初に [`findall`](@ref) を呼び出すのではなく、インデックスとしてブール配列を直接使用する方が効率的です。

```jldoctest
julia> x = reshape(1:12, 2, 3, 2)
2×3×2 reshape(::UnitRange{Int64}, 2, 3, 2) with eltype Int64:
[:, :, 1] =
 1  3  5
 2  4  6

[:, :, 2] =
 7   9  11
 8  10  12

julia> x[:, [true false; false true; true false]]
2×3 Matrix{Int64}:
 1  5   9
 2  6  10

julia> mask = map(ispow2, x)
2×3×2 Array{Bool, 3}:
[:, :, 1] =
 1  0  0
 1  1  0

[:, :, 2] =
 0  0  0
 1  0  0

julia> x[mask]
4-element Vector{Int64}:
 1
 2
 4
 8

julia> x[vec(mask)] == x[mask] # we can also index with a single Boolean vector
true
```

### Number of indices

#### Cartesian indexing

`N`次元配列にインデックスを付ける一般的な方法は、正確に`N`個のインデックスを使用することです。各インデックスは、その特定の次元における位置を選択します。例えば、三次元配列`A = rand(4, 3, 2)`において、`A[2, 3, 1]`は配列の最初の「ページ」の第三列の第二行の数値を選択します。これはしばしば*デカルトインデックス*と呼ばれます。

#### Linear indexing

インデックス `i` が正確に1つ提供されると、そのインデックスは配列の特定の次元の位置を表さなくなります。代わりに、配列全体を線形にスパンする列優先の反復順序を使用して `i` 番目の要素を選択します。これは *線形インデックス* として知られています。これは本質的に、配列が [`vec`](@ref) の1次元ベクトルに再形成されたかのように扱います。

```jldoctest linindexing
julia> A = [2 6; 4 7; 3 1]
3×2 Matrix{Int64}:
 2  6
 4  7
 3  1

julia> A[5]
7

julia> vec(A)[5]
7
```

配列 `A` への線形インデックスは、`CartesianIndices(A)[i]` を使用してカートesianインデックスに変換できます（[`CartesianIndices`](@ref) を参照）。また、`N` 個のカートesianインデックスのセットは、`LinearIndices(A)[i_1, i_2, ..., i_N]` を使用して線形インデックスに変換できます（[`LinearIndices`](@ref) を参照）。

```jldoctest linindexing
julia> CartesianIndices(A)[5]
CartesianIndex(2, 2)

julia> LinearIndices(A)[2, 2]
5
```

重要な点は、これらの変換のパフォーマンスに非常に大きな非対称性があることです。線形インデックスを一連の直交インデックスに変換するには、割り算と余りを取る必要がありますが、逆にするのは単に掛け算と足し算だけです。現代のプロセッサでは、整数の割り算は掛け算の10〜50倍遅くなることがあります。一部の配列 — 例えば [`Array`](@ref) 自体 — は、線形メモリチャンクを使用して実装されており、その実装で線形インデックスを直接使用していますが、他の配列 — 例えば [`Diagonal`](@ref) — は、ルックアップを行うために完全な直交インデックスのセットが必要です（どれがどれかを調べるには [`IndexStyle`](@ref) を参照してください）。

!!! warning
    配列のすべてのインデックスを反復処理する際には、[`eachindex(A)`](@ref) を反復処理する方が、`1:length(A)` よりも優れています。これは、`A` が `IndexCartesian` の場合に速くなるだけでなく、[OffsetArrays](https://github.com/JuliaArrays/OffsetArrays.jl) のようなカスタムインデックスを持つ配列もサポートします。値のみが必要な場合は、配列を直接反復処理する方が良い、つまり `for a in A` とします。


#### Omitted and extra indices

線形インデックスに加えて、`N` 次元配列は、特定の状況で `N` より少ないまたは多いインデックスでインデックス付けされる場合があります。

インデックスは、インデックスが指定されていない末尾の次元がすべて長さ1である場合に省略できます。言い換えれば、末尾のインデックスは、インデックスが省略された場合に、そのインデックスが有効なインデックス式に対して取ることができる値が1つだけである場合にのみ省略できます。例えば、サイズが `(3, 4, 2, 1)` の4次元配列は、スキップされる次元（4次元目）が長さ1であるため、3つのインデックスだけでインデックス指定できます。このルールよりも線形インデックスが優先されることに注意してください。

```jldoctest
julia> A = reshape(1:24, 3, 4, 2, 1)
3×4×2×1 reshape(::UnitRange{Int64}, 3, 4, 2, 1) with eltype Int64:
[:, :, 1, 1] =
 1  4  7  10
 2  5  8  11
 3  6  9  12

[:, :, 2, 1] =
 13  16  19  22
 14  17  20  23
 15  18  21  24

julia> A[1, 3, 2] # Omits the fourth dimension (length 1)
19

julia> A[1, 3] # Attempts to omit dimensions 3 & 4 (lengths 2 and 1)
ERROR: BoundsError: attempt to access 3×4×2×1 reshape(::UnitRange{Int64}, 3, 4, 2, 1) with eltype Int64 at index [1, 3]

julia> A[19] # Linear indexing
19
```

`A[]`を使用して*すべての*インデックスを省略すると、このセマンティクスは配列内の唯一の要素を取得し、同時に要素が1つだけであることを保証するシンプルなイディオムを提供します。

同様に、配列の次元を超えるすべてのインデックスが `1` である場合（または一般的には `axes(A, d)` の最初の要素である場合）、`N` より多くのインデックスを提供することができます。これにより、ベクトルを1列の行列のようにインデックス指定することができます。例えば：

```jldoctest
julia> A = [8, 6, 7]
3-element Vector{Int64}:
 8
 6
 7

julia> A[2, 1]
6
```

## Iteration

配列全体を反復処理するための推奨方法は次のとおりです。

```julia
for a in A
    # Do something with the element a
end

for i in eachindex(A)
    # Do something with i and/or A[i]
end
```

最初の構文は、各要素の値が必要だがインデックスは必要ない場合に使用されます。2番目の構文では、`i`は、`A`が高速な線形インデックスを持つ配列型であれば`Int`になります。それ以外の場合は`CartesianIndex`になります。

```jldoctest
julia> A = rand(4, 3);

julia> B = view(A, 1:3, 2:3);

julia> for i in eachindex(B)
           @show i
       end
i = CartesianIndex(1, 1)
i = CartesianIndex(2, 1)
i = CartesianIndex(3, 1)
i = CartesianIndex(1, 2)
i = CartesianIndex(2, 2)
i = CartesianIndex(3, 2)
```

!!! note
    `for i = 1:length(A)`と対照的に、[`eachindex`](@ref)を使用して反復処理を行うことは、任意の配列タイプを効率的に反復処理する方法を提供します。さらに、これは[OffsetArrays](https://github.com/JuliaArrays/OffsetArrays.jl)のようなカスタムインデックスを持つジェネリック配列もサポートしています。


## Array traits

カスタム [`AbstractArray`](@ref) タイプを作成する場合、次のようにして高速な線形インデックスを指定できます。

```julia
Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()
```

この設定により、`MyArray` に対する `eachindex` の反復処理で整数が使用されます。この特性を指定しない場合、デフォルト値の `IndexCartesian()` が使用されます。

## [Array and Vectorized Operators and Functions](@id man-array-and-vectorized-operators-and-functions)

配列に対してサポートされている演算子は次のとおりです：

1. 単項算術 – `-`, `+`
2. バイナリ算術 – `-`, `+`, `*`, `/`, `\`, `^`
3. 比較 – `==`, `!=`, `≈` ([`isapprox`](@ref)), `≉`

数学やその他の操作の便利なベクトル化を可能にするために、Julia [provides the dot syntax](@ref man-vectorized) `f.(args...)`、例えば `sin.(x)` や `min.(x, y)` のように、配列や配列とスカラーの混合に対する要素ごとの操作を行います（これは [Broadcasting](@ref) 操作です）。これらは、他のドット呼び出しと組み合わせたときに「融合」して単一のループにまとめられるという追加の利点があります。例えば `sin.(cos.(x))` のように。

また、*すべての* 二項演算子は、配列（および配列とスカラーの組み合わせ）に適用できる [dot version](@ref man-dot-operators) をサポートしています。例えば、`z .== sin.(x .* y)` のように、[fused broadcasting operations](@ref man-vectorized) で使用できます。

配列全体に対して `==` のような比較を行うと、単一のブール値が返されることに注意してください。要素ごとの比較には `.==` のようなドット演算子を使用してください。（`<` のような比較演算に関しては、配列に適用できるのは要素ごとの `.<` バージョンのみです。）

Also notice the difference between `max.(a,b)`, which [`broadcast`](@ref)s [`max`](@ref) elementwise over `a` and `b`, and [`maximum(a)`](@ref), which finds the largest value within `a`. The same relationship holds for `min.(a, b)` and `minimum(a)`.

## Broadcasting

異なるサイズの配列に対して要素ごとの二項演算を行うことは、時には便利です。たとえば、ベクトルを行列の各列に加える場合などです。この操作を行う非効率的な方法は、ベクトルを行列のサイズに複製することです：

```julia-repl
julia> a = rand(2, 1); A = rand(2, 3);

julia> repeat(a, 1, 3) + A
2×3 Array{Float64,2}:
 1.20813  1.82068  1.25387
 1.56851  1.86401  1.67846
```

これは次元が大きくなると無駄が生じるため、Juliaは [`broadcast`](@ref) を提供します。これは、配列引数の単一次元を他の配列の対応する次元に合わせて拡張し、追加のメモリを使用せずに、指定された関数を要素ごとに適用します。

```julia-repl
julia> broadcast(+, a, A)
2×3 Array{Float64,2}:
 1.20813  1.82068  1.25387
 1.56851  1.86401  1.67846

julia> b = rand(1,2)
1×2 Array{Float64,2}:
 0.867535  0.00457906

julia> broadcast(+, a, b)
2×2 Array{Float64,2}:
 1.71056  0.847604
 1.73659  0.873631
```

[Dotted operators](@ref man-dot-operators) のように `.+` や `.*` は `broadcast` 呼び出しに相当します（ただし、これらは融合するため、[described above](@ref man-array-and-vectorized-operators-and-functions)）。明示的な宛先を指定するための [`broadcast!`](@ref) 関数もあり（これは `.=` 代入によって融合的にアクセスすることもできます）。実際、`f.(args...)` は `broadcast(f, args...)` に相当し、任意の関数をブロードキャストするための便利な構文を提供します（[dot syntax](@ref man-vectorized)）。ネストされた "ドット呼び出し" `f.(...)`（`.+` などへの呼び出しを含む） [automatically fuse](@ref man-dot-operators) を単一の `broadcast` 呼び出しにまとめます。

さらに、[`broadcast`](@ref) は配列に限定されず（関数のドキュメントを参照）、スカラー、タプル、その他のコレクションも処理します。デフォルトでは、いくつかの引数タイプのみがスカラーと見なされ、これには（ただしこれに限定されない）`Number`、`String`、`Symbol`、`Type`、`Function`、および `missing` や `nothing` のような一般的なシングルトンが含まれます。その他の引数は要素ごとに反復処理されるか、インデックス化されます。

```jldoctest
julia> convert.(Float32, [1, 2])
2-element Vector{Float32}:
 1.0
 2.0

julia> ceil.(UInt8, [1.2 3.4; 5.6 6.7])
2×2 Matrix{UInt8}:
 0x02  0x04
 0x06  0x07

julia> string.(1:3, ". ", ["First", "Second", "Third"])
3-element Vector{String}:
 "1. First"
 "2. Second"
 "3. Third"
```

時には、通常ブロードキャストに参加するコンテナ（配列のようなもの）が、すべての要素を反復処理するブロードキャストの動作から「保護」されることを望むことがあります。別のコンテナ（単一の要素 [`Tuple`](@ref) のようなもの）の中に置くことで、ブロードキャストはそれを単一の値として扱います。

```jldoctest
julia> ([1, 2, 3], [4, 5, 6]) .+ ([1, 2, 3],)
([2, 4, 6], [5, 7, 9])

julia> ([1, 2, 3], [4, 5, 6]) .+ tuple([1, 2, 3])
([2, 4, 6], [5, 7, 9])
```

## Implementation

Juliaの基本配列型は抽象型[`AbstractArray{T,N}`](@ref)です。これは次元数`N`と要素型`T`によってパラメータ化されています。[`AbstractVector`](@ref)と[`AbstractMatrix`](@ref)は1次元および2次元の場合のエイリアスです。`AbstractArray`オブジェクトに対する操作は、基盤となるストレージに依存しない方法で、高レベルの演算子や関数を使用して定義されています。これらの操作は、特定の配列実装に対するフォールバックとして一般的に正しく機能します。

`AbstractArray` 型は、配列のようなものを含み、その実装は従来の配列とはかなり異なる場合があります。たとえば、要素は保存されるのではなく、要求に応じて計算されることがあります。ただし、具体的な `AbstractArray{T,N}` 型は、一般的に少なくとも [`size(A)`](@ref)（`Int` タプルを返す）、[`getindex(A, i)`](@ref) および [`getindex(A, i1, ..., iN)`](@ref getindex) を実装する必要があります。可変配列は、[`setindex!`](@ref) も実装する必要があります。これらの操作はほぼ定数時間の複雑さを持つことが推奨されます。そうでない場合、一部の配列関数が予期せず遅くなる可能性があります。具体的な型は、[`similar(A, T=eltype(A), dims=size(A))`](@ref) メソッドも提供する必要があります。これは、[`copy`](@ref) およびその他のアウトオブプレース操作のために、類似の配列を割り当てるために使用されます。`AbstractArray{T,N}` が内部的にどのように表現されていても、`T` は *整数* インデックス（`A[1, ..., 1]`、`A` が空でない場合）によって返されるオブジェクトの型であり、`N` は [`size`](@ref) によって返されるタプルの長さである必要があります。カスタム `AbstractArray` 実装の定義に関する詳細については、[array interface guide in the interfaces chapter](@ref man-interface-array) を参照してください。

`DenseArray`は、要素が列優先順序で連続して格納されるすべての配列を含むことを目的とした`AbstractArray`の抽象サブタイプです（詳細は[additional notes in Performance Tips](@ref man-performance-column-major)を参照してください）。[`Array`](@ref)型は`DenseArray`の特定のインスタンスです。[`Vector`](@ref)および[`Matrix`](@ref)は1次元および2次元の場合のエイリアスです。`Array`に特化して実装されている操作は非常に少なく、すべての`AbstractArray`に必要な操作を超えたものはありません。配列ライブラリの多くは、すべてのカスタム配列が同様に動作できるように、一般的な方法で実装されています。

`SubArray` は、元の配列とメモリを共有することでインデックスを行う `AbstractArray` の特化型です。`SubArray` は、[`view`](@ref) 関数を使用して作成され、これは [`getindex`](@ref) と同じ方法で呼び出されます（配列と一連のインデックス引数を使用）。`4d61726b646f776e2e436f64652822222c2022766965772229_40726566` の結果は、`4d61726b646f776e2e436f64652822222c2022676574696e6465782229_40726566` の結果と同じように見えますが、データはそのまま残ります。`4d61726b646f776e2e436f64652822222c2022766965772229_40726566` は、入力インデックスベクトルを `SubArray` オブジェクトに格納し、これを使用して元の配列を間接的にインデックスすることができます。式やコードブロックの前に [`@views`](@ref) マクロを置くことで、その式内の任意の `array[...]` スライスは、`SubArray` ビューを作成するように変換されます。

[`BitArray`](@ref)は、1つのブール値につき1ビットを格納する、スペース効率の良い「パックされた」ブール配列です。これらは、1つのブール値につき1バイトを格納する`Array{Bool}`配列と同様に使用でき、`Array(bitarray)`および`BitArray(array)`を介してそれぞれ相互に変換できます。

配列は、要素間に明確に定義された間隔（ストライド）を持ってメモリに格納されている場合、「ストライドされた」と言います。サポートされている要素タイプを持つストライド配列は、[`pointer`](@ref) と各次元のストライドを単に渡すことで、BLAS や LAPACK のような外部（非 Julia）ライブラリに渡すことができます。[`stride(A, d)`](@ref) は、次元 `d` に沿った要素間の距離です。たとえば、`rand(5,7,2)` によって返される組み込みの `Array` は、要素が列優先順に連続して配置されています。これは、最初の次元のストライド — 同じ列内の要素間の間隔 — が `1` であることを意味します。

```julia-repl
julia> A = rand(5, 7, 2);

julia> stride(A, 1)
1
```

第二次元のストライドは、同じ行の要素間の間隔であり、単一の列にある要素の数（`5`）だけスキップします。同様に、2つの「ページ」（第三次元）間をジャンプするには、`5*7 == 35` 要素をスキップする必要があります。この配列の [`strides`](@ref) は、これら3つの数のタプルです。

```julia-repl
julia> strides(A)
(1, 5, 35)
```

この特定のケースでは、*メモリ内*でスキップされた要素の数がスキップされた*線形インデックス*の数と一致します。これは、`Array`（および他の`DenseArray`サブタイプ）のような連続配列にのみ当てはまり、一般的には真ではありません。範囲インデックスを持つビューは、*非連続*ストライド配列の良い例です。`V = @view A[1:3:4, 2:2:6, 2:-1:1]`を考えてみてください。このビュー`V`は`A`と同じメモリを参照していますが、一部の要素をスキップして再配置しています。`V`の最初の次元のストライドは`3`であり、元の配列から3行ごとに選択しているためです。

```julia-repl
julia> V = @view A[1:3:4, 2:2:6, 2:-1:1];

julia> stride(V, 1)
3
```

このビューは、元の `A` から他のすべての列を同様に選択しており、したがって、2次元のインデックス間を移動する際に、5要素の列2つに相当するものをスキップする必要があります。

```julia-repl
julia> stride(V, 2)
10
```

第三の次元は興味深いです。なぜなら、その順序が逆だからです！したがって、最初の「ページ」から2番目のページに移動するには、メモリの中で*逆方向*に進む必要があり、この次元でのストライドは負になります！

```julia-repl
julia> stride(V, 3)
-35
```

これは、`V`の`ポインタ`が実際には`A`のメモリブロックの中央を指しており、メモリ内の前後の要素を参照していることを意味します。独自のストライド配列を定義する詳細については、[interface guide for strided arrays](@ref man-interface-strided-arrays)を参照してください。[`StridedVector`](@ref)および[`StridedMatrix`](@ref)は、ストライド配列と見なされる多くの組み込み配列タイプの便利なエイリアスであり、ポインタとストライドを使用して、高度に調整された最適化されたBLASおよびLAPACK関数を呼び出す特化した実装を選択するためにディスパッチすることを可能にします。

メモリ内のオフセットに関するものであり、インデックス付けではないことを強調する価値があります。線形（単一インデックス）インデックスと直交（多重インデックス）インデックスの間で変換を行う場合は、[`LinearIndices`](@ref) と [`CartesianIndices`](@ref) を参照してください。

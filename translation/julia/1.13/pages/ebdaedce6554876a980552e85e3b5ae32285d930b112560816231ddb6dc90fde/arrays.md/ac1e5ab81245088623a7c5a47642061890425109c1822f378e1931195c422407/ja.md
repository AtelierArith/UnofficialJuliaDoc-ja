# [Single- and multi-dimensional Arrays](@id man-multi-dim-arrays)

Juliaは、ほとんどの技術計算言語と同様に、配列を第一級の機能として実装しています。多くの技術計算言語では、ほかのコンテナを犠牲にして配列の実装に力を注いでいますが、Juliaでは配列を特別扱いしません。配列ライブラリはほぼすべてJulia自体で実装されており、Juliaで書かれたほかのコードと同じように、コンパイラによって性能を引き出しています。そのため、[`AbstractArray`](@ref)を継承して独自の配列型を定義することもできます。独自の配列型の実装について詳しくは、[manual section on the AbstractArray interface](@ref man-interface-array)を参照してください。

配列は、多次元の格子状に格納されたオブジェクトの集まりです。0次元の配列も使用できます。[this FAQ entry](@ref faq-array-0dim)を参照してください。最も一般的な場合、配列には[`Any`](@ref)型のオブジェクトを格納できます。ただし、ほとんどの計算用途では、[`Float64`](@ref)や[`Int32`](@ref)など、より具体的な型のオブジェクトを格納するべきです。

一般にJuliaでは、ほかの多くの技術計算言語とは異なり、性能のためにプログラムをベクトル化したスタイルで書く必要はありません。Juliaのコンパイラは型推論を使い、スカラーによる配列のインデックスアクセスに対して最適化されたコードを生成します。そのため、性能を犠牲にすることなく、書きやすく読みやすいスタイルでプログラムを記述でき、ときにはメモリ使用量も削減できます。

Juliaでは、関数の引数はすべて[passed by sharing](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_sharing)（つまりポインタによって渡されます）。一部の技術計算言語では配列を値渡しします。これにより、呼び出された関数が呼び出し元の値を誤って変更することは防げますが、不要な配列のコピーを避けるのが難しくなります。慣例として、名前が`!`で終わる関数は、1つ以上の引数の値を変更または破壊することを示します（たとえば、[`sort`](@ref)と[`sort!`](@ref)を比較してください）。呼び出された関数は、変更するつもりのない入力を変更しないように、明示的にコピーを作る必要があります。入力を変更しない関数の多くは、入力を明示的にコピーし、同じ名前の末尾に`!`を付けた関数をそのコピーに対して呼び出してから、コピーを返す形で実装されています。

## Basic Functions

| 関数                     | 説明                               |
|:---------------------- |:-------------------------------- |
| [`eltype(A)`](@ref)    | `A`に含まれる要素の型                     |
| [`length(A)`](@ref)    | `A`の要素数                          |
| [`ndims(A)`](@ref)     | `A`の次元数                          |
| [`size(A)`](@ref)      | `A`の各次元のサイズを含むタプル                |
| [`size(A,n)`](@ref)    | `A`の第`n`次元のサイズ                   |
| [`axes(A)`](@ref)      | `A`の有効なインデックス範囲を含むタプル            |
| [`axes(A,n)`](@ref)    | 第`n`次元の有効なインデックスを表す範囲            |
| [`eachindex(A)`](@ref) | `A`の各位置を走査するための効率的なイテレータ         |
| [`stride(A,k)`](@ref)  | 第`k`次元のストライド（隣接する要素間の線形インデックスの差） |
| [`strides(A)`](@ref)   | 各次元のストライドをまとめたタプル                |

## Construction and Initialization

配列の構築と初期化のために、多数の関数が用意されています。以下に示す関数のうち、`dims...`引数を取るものでは、各次元のサイズを1つのタプルとして渡すことも、可変個の引数として個別に渡すこともできます。また、これらの関数のほとんどは、配列の要素型を指定する`T`を最初の引数として受け取ります。型`T`を省略すると、デフォルトは[`Float64`](@ref)になります。

| 関数                                 | 説明                                                                                |
|:---------------------------------- |:--------------------------------------------------------------------------------- |
| [`Array{T}(undef, dims...)`](@ref) | 未初期化の密な[`Array`](@ref)                                                            |
| [`zeros(T, dims...)`](@ref)        | すべての要素が0の`Array`                                                                  |
| [`ones(T, dims...)`](@ref)         | すべての要素が1の`Array`                                                                  |
| [`trues(dims...)`](@ref)           | すべての値が`true`の[`BitArray`](@ref)                                                   |
| [`falses(dims...)`](@ref)          | すべての値が`false`の`BitArray`                                                          |
| [`reshape(A, dims...)`](@ref)      | `A`と同じデータを含み、形状が異なる配列                                                             |
| [`copy(A)`](@ref)                  | `A`をコピー                                                                           |
| [`deepcopy(A)`](@ref)              | 要素を再帰的にコピーしながら、`A`をコピー                                                            |
| [`similar(A, T, dims...)`](@ref)   | `A`と同じ種類（密、疎など）で、指定された要素型と形状を持つ未初期化の配列。第2引数と第3引数はいずれも省略可能で、省略すると`A`の要素型と形状が使われます。 |
| [`reinterpret(T, A)`](@ref)        | `A`と同じバイナリデータを持ち、要素型が`T`の配列                                                       |
| [`rand(T, dims...)`](@ref)         | 独立同分布（iid）[^1]の一様乱数を値とする`Array`。浮動小数点型`T`の場合、値は半開区間``[0, 1)``に入ります。               |
| [`randn(T, dims...)`](@ref)        | 独立同分布の標準正規乱数を値とする`Array`                                                          |
| [`Matrix{T}(I, m, n)`](@ref)       | `m`行`n`列の単位行列。[`I`](@ref)を使うには`using LinearAlgebra`が必要です。                         |
| [`range(start, stop, n)`](@ref)    | `start`から`stop`までの、等間隔に並んだ`n`個の要素からなる範囲                                           |
| [`fill!(A, x)`](@ref)              | 配列`A`を値`x`で埋める                                                                    |
| [`fill(x, dims...)`](@ref)         | 値`x`で埋められた`Array`。特に、`fill(x)`は`x`を含む0次元の`Array`を構築します。                           |

[^1]: *iid*：独立同分布（independently and identically distributed）。

これらの関数に各次元のサイズを渡すさまざまな方法を、次の例で確認しましょう。

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

ここで、`(2, 3)`は[`Tuple`](@ref)です。また、最初の引数である要素型は省略可能で、デフォルトは`Float64`です。

## [Array literals](@id man-array-literals)

配列は角括弧を使って直接構築することもできます。構文`[A, B, C, ...]`は、カンマで区切った引数を要素とする1次元配列（ベクトル）を作ります。結果の配列の要素型（[`eltype`](@ref)）は、括弧内の引数の型から自動的に決まります。すべての引数が同じ型なら、それが`eltype`になります。すべての引数に共通の[promotion type](@ref conversion-and-promotion)がある場合は、[`convert`](@ref)を使ってその型に変換され、その型が配列の`eltype`になります。それ以外の場合は、あらゆる値を格納できる異種混在配列`Vector{Any}`が構築されます。引数を指定しないリテラル`[]`もこれに含まれます。`T`を型として、構文`T[A, B, C, ...]`で[Array literals can be typed](@ref man-array-typed-literal)。

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

角括弧内の引数をカンマではなく単一のセミコロン（`;`）または改行で区切ると、引数自体が要素になるのではなく、引数の内容が*垂直方向に連結*されます。

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

同様に、引数をタブ、空白、または二重セミコロンで区切ると、その内容が*水平方向に連結*されます。

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

単一のセミコロン（または改行）と空白（またはタブ）を組み合わせると、水平方向と垂直方向に同時に連結できます。

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

空白（およびタブ）はセミコロンよりも優先順位が高いため、まず水平方向の連結がすべて行われ、その結果が連結されます。一方、水平方向の連結に二重セミコロンを使うと、まず垂直方向の連結がすべて行われ、その結果が水平方向に連結されます。

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

`;`と`;;`がそれぞれ第1次元と第2次元で連結するのと同じ仕組みを、セミコロンの数を増やすことで拡張できます。区切りに使うセミコロンの数が連結する次元を指定するため、`;;;`は第3次元、`;;;;`は第4次元で連結し、以降も同様です。セミコロンの数が少ないほうが優先されるため、一般に低い次元から先に連結されます。

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

先ほどと同様、水平方向の連結に使う空白（およびタブ）は、何個のセミコロンよりも優先順位が高くなります。そのため、高次元の配列も、まず行を指定し、要素を実際の配置に似た形で並べて記述できます。

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

空白（またはタブ）と`;;`はどちらも第2次元での連結を表しますが、二重セミコロンが単に「行継続」文字として機能する場合を除き、同じ配列式に混在させることはできません。この行継続により、改行が垂直方向の連結と解釈されることなく、1つの水平方向の連結を複数行にわたって記述できます。

```jldoctest
julia> [1 2 ;;
       3 4]
1×4 Matrix{Int64}:
 1  2  3  4
```

末尾にセミコロンを付けると、長さ1の次元を末尾に追加することもできます。

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

より一般的には、[`cat`](@ref)関数を使って連結できます。これらの構文は、利便性のために用意された関数の呼び出しを短く表すものです。

| 構文                     | 関数               | 説明                          |
|:---------------------- |:---------------- |:--------------------------- |
|                        | [`cat`](@ref)    | 入力配列を`k`で指定した次元に沿って連結       |
| `[A; B; C; ...]`       | [`vcat`](@ref)   | `cat(A...; dims=1)`の短縮形     |
| `[A B C ...]`          | [`hcat`](@ref)   | `cat(A...; dims=2)`の短縮形     |
| `[A B; C D; ...]`      | [`hvcat`](@ref)  | 垂直方向と水平方向の同時連結              |
| `[A; C;; B; D;;; ...]` | [`hvncat`](@ref) | n次元での同時連結。セミコロンの数が連結する次元を指定 |

### [Typed array literals](@id man-array-typed-literal)

構文`T[A, B, C, ...]`を使うと、特定の要素型を持つ配列を構築できます。これは、要素型が`T`で、`A`、`B`、`C`などを要素として含むように初期化された1次元配列を構築します。たとえば、`Any[x, y, z]`は、任意の値を格納できる異種混在配列を構築します。

連結構文にも同様に型を前置して、結果の要素型を指定できます。

```jldoctest
julia> [[1 2] [3 4]]
1×4 Matrix{Int64}:
 1  2  3  4

julia> Int8[[1 2] [3 4]]
1×4 Matrix{Int8}:
 1  2  3  4
```

## [Comprehensions](@id man-comprehensions)

内包表記は、配列を構築するための汎用的で強力な方法です。内包表記の構文は、数学における集合の構成表記に似ています。

```julia
A = [ F(x, y, ...) for x=rx, y=ry, ... ]
```

この形式では、変数`x`、`y`などが、それぞれに指定された値のリストの各値を取り、そのつど`F(x,y,...)`が評価されます。値の指定には任意の反復可能オブジェクトを使えますが、通常は`1:n`や`2:(n-1)`のような範囲、または`[1.2, 3.4, 5.7]`のように値を明示した配列を使います。結果はN次元の密な配列で、その形状は各変数の範囲`rx`、`ry`などの形状を連結したものになります。`F(x,y,...)`の各評価はスカラーを返します。

次の例では、1次元格子上の現在の要素と、その左右の隣接要素の加重平均を計算します。

```jldoctest
julia> x = [4, 8, 2, 6, 10, 10, 2, 8]
8-element Vector{Int64}:
  4
  8
  2
  6
 10
 10
  2
  8

julia> [ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
6-element Vector{Float64}:
 5.5
 4.5
 6.0
 9.0
 8.0
 5.5
```

結果の配列の型は、[array literals](@ref man-array-literals)と同様に、計算された要素の型によって決まります。型を明示的に制御するには、内包表記の前に型を付けます。たとえば、次のように書けば、結果を単精度で求めることができます。

```julia
Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
```

## [Generator Expressions](@id man-generators)

内包表記は外側の角括弧を省いて書くこともでき、その場合はジェネレータと呼ばれるオブジェクトが生成されます。このオブジェクトを反復処理すると、配列を割り当てて値をあらかじめ格納しておくのではなく、必要に応じて値を生成できます（[Iteration](@ref)を参照）。たとえば、次の式はメモリを割り当てずに級数の和を計算します。

```jldoctest
julia> sum(1/n^2 for n=1:1000)
1.6439345666815615
```

引数リスト内に複数の次元を持つジェネレータ式を書く場合は、ジェネレータと後続の引数を区別するために丸括弧が必要です。

```jldoctest
julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
ERROR: ParseError:
# Error @ none:1:44
map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
#                                          └ ── invalid iteration spec: expected one of `=` `in` or `∈`
```

`for`より後ろのカンマ区切りの式は、すべて範囲として解釈されます。丸括弧を追加すると、[`map`](@ref)に第3引数を渡せます。

```jldoctest
julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
2×2 Matrix{Tuple{Float64, Int64}}:
 (0.5, 1)       (0.333333, 3)
 (0.333333, 2)  (0.25, 4)
```

ジェネレータは内部関数を使って実装されています。言語のほかの箇所で使われる内部関数と同様に、外側のスコープの変数を内部関数に「キャプチャ」できます。たとえば、`sum(p[i] - q[i] for i=1:n)`は、外側のスコープから3つの変数`p`、`q`、`n`をキャプチャします。キャプチャされた変数は、性能上の問題を引き起こすことがあります。[performance tips](@ref man-performance-captured)を参照してください。

ジェネレータと内包表記では、`for`キーワードを複数書くことで、先行する範囲に依存する範囲を指定できます。

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

この場合、結果は常に1次元になります。

生成される値は、`if`キーワードを使って絞り込めます。

```jldoctest
julia> [(i, j) for i=1:3 for j=1:i if i+j == 4]
2-element Vector{Tuple{Int64, Int64}}:
 (2, 2)
 (3, 1)
```

## [Indexing](@id man-array-indexing)

n次元配列`A`へのインデックスアクセスの一般的な構文は次のとおりです。

```
X = A[I_1, I_2, ..., I_n]
```

各`I_k`には、整数スカラー、整数の配列、またはその他の[supported index](@ref man-supported-index-types)を指定できます。これには、その次元のすべてのインデックスを選択する[`Colon`](@ref)（`:`）、連続した部分または一定間隔の部分を選択する`a:c`や`a:b:c`の形式の範囲、および値が`true`である位置の要素を選択する真偽値の配列が含まれます。

すべてのインデックスがスカラーなら、結果`X`は配列`A`の単一の要素になります。それ以外の場合、`X`は、すべてのインデックスの次元数の合計と同じ次元数の配列になります。

たとえば、すべてのインデックス`I_k`がベクトルなら、`X`の形状は`(length(I_1), length(I_2), ..., length(I_n))`になり、`X`の位置`i_1, i_2, ..., i_n`には、値`A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]`が格納されます。

例：

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

最後の2つの場合で、結果の配列のサイズが異なることに注意してください。

`I_1`を2次元行列に変えると、`X`は形状が`(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))`の`n+1`次元配列になります。この行列によって次元が1つ増えます。

例：

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

位置`i_1, i_2, i_3, ..., i_{n+1}`には、`A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]`にある値が格納されます。スカラーで指定した次元はすべて取り除かれます。たとえば、`J`がインデックスの配列なら、`A[2, J, 3]`の結果はサイズ`size(J)`の配列になります。その第`j`要素には、`A[2, J[j], 3]`が格納されます。

この構文の特別な機能として、インデックス指定の角括弧内では、`end`キーワードで各次元の最後のインデックスを表せます。その値は、インデックスアクセスの対象となる最も内側の配列のサイズによって決まります。`end`キーワードを含まないインデックス構文は、[`getindex`](@ref)の呼び出しと等価です。

```
X = getindex(A, I_1, I_2, ..., I_n)
```

例：

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

n次元配列`A`に値を代入する一般的な構文は次のとおりです。

```
A[I_1, I_2, ..., I_n] = X
```

各`I_k`には、整数スカラー、整数の配列、またはその他の[supported index](@ref man-supported-index-types)を指定できます。これには、その次元のすべてのインデックスを選択する[`Colon`](@ref)（`:`）、連続した部分または一定間隔の部分を選択する`a:c`や`a:b:c`の形式の範囲、および値が`true`である位置の要素を選択する真偽値の配列が含まれます。

すべてのインデックス`I_k`が整数なら、`A`の位置`I_1, I_2, ..., I_n`の値は、`X`の値で上書きされます。必要に応じて、`A`の[`eltype`](@ref)への[`convert`](@ref)が行われます。

インデックス`I_k`のいずれかが配列である場合、右辺`X`も、インデックスアクセス`A[I_1, I_2, ..., I_n]`の結果と同じ形状の配列か、同じ要素数のベクトルでなければなりません。`A`の位置`I_1[i_1], I_2[i_2], ..., I_n[i_n]`の値は、必要に応じて変換された値`X[i_1, i_2, ..., i_n]`で上書きされます。要素ごとの代入演算子`.=`を使えば、選択した各位置に`X`を[broadcast](@ref Broadcasting)できます。

```
A[I_1, I_2, ..., I_n] .= X
```

[Indexing](@ref man-array-indexing)と同様に、インデックス指定の角括弧内では、`end`キーワードで各次元の最後のインデックスを表せます。その値は、代入先の配列のサイズによって決まります。`end`キーワードを含まないインデックス付き代入の構文は、[`setindex!`](@ref)の呼び出しと等価です。

```
setindex!(A, X, I_1, I_2, ..., I_n)
```

例：

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

式`A[I_1, I_2, ..., I_n]`の各`I_k`には、スカラーインデックス、スカラーインデックスの配列、またはスカラーインデックスの配列を表し、[`to_indices`](@ref)でそのような配列に変換できるオブジェクトを指定できます。

1. スカラーインデックス。デフォルトでは次が含まれます。

      * 真偽値以外の整数
      * 複数の次元にまたがる整数の`N`要素タプルのように振る舞う[`CartesianIndex{N}`](@ref)（詳細は後述）
2. スカラーインデックスの配列。次が含まれます。

      * 整数のベクトルおよび多次元配列
      * 要素を選択しない`[]`のような空配列。例：`A[[]]`（`A[]`と混同しないでください）
      * `a`から`c`まで（両端を含む）の、連続した部分または一定間隔の部分を選択する`a:c`や`a:b:c`のような範囲
      * `AbstractArray`のサブタイプである、独自のスカラーインデックス配列
      * `CartesianIndex{N}`の配列（詳細は後述）
3. スカラーインデックスの配列を表し、[`to_indices`](@ref)でそのような配列に変換できるオブジェクト。デフォルトでは次が含まれます。

      * ある次元全体、または配列全体のすべてのインデックスを表す[`Colon()`](@ref)（`:`）
      * 値が`true`である位置の要素を選択する真偽値の配列（詳細は後述）

いくつかの例：

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

特殊なオブジェクト`CartesianIndex{N}`は、複数の次元にまたがる整数の`N`要素タプルのように振る舞うスカラーインデックスを表します。たとえば、次のように使えます。

```jldoctest cartesianindex
julia> A = reshape(1:32, 4, 4, 2);

julia> A[3, 2, 1]
7

julia> A[CartesianIndex(3, 2, 1)] == A[3, 2, 1] == 7
true
```

これだけを見ると、あまり重要ではないように思えるかもしれません。`CartesianIndex`は、単に複数の整数を、1つの多次元インデックスを表すオブジェクトにまとめているだけです。しかし、ほかのインデックス形式や`CartesianIndex`を生成するイテレータと組み合わせると、非常に簡潔で効率的なコードを書けます。後述の[Iteration](@ref)を参照してください。より高度な例については、[this blog post on multidimensional algorithms and iteration](https://julialang.org/blog/2016/02/iteration)を参照してください。

`CartesianIndex{N}`の配列もサポートされています。これは、それぞれが`N`次元にまたがるスカラーインデックスの集まりを表し、点ごとのインデックス指定（pointwise indexing）と呼ばれる形式を可能にします。たとえば、先ほどの`A`の最初の「ページ」から対角要素を取り出せます。

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

これは、[dot broadcasting](@ref man-vectorized)を使い、通常の整数インデックスと組み合わせると、はるかに簡単に表現できます（`A`から最初の`page`を別の手順で取り出す必要はありません）。さらに`:`と組み合わせれば、2つのページの対角要素を同時に取り出すこともできます。

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
    `CartesianIndex`と`CartesianIndex`の配列は、次元の最後のインデックスを表す`end`キーワードと併用できません。`CartesianIndex`またはその配列が含まれる可能性のあるインデックス式では、`end`を使わないでください。


### Logical indexing

真偽値の配列によるインデックスアクセスは、論理インデックスアクセス、または論理マスクによるインデックスアクセスとも呼ばれ、値が`true`である位置の要素を選択します。真偽値ベクトル`B`によるインデックスアクセスは、実質的に[`findall(B)`](@ref)が返す整数ベクトルによるインデックスアクセスと同じです。同様に、`N`次元の真偽値配列によるインデックスアクセスは、実質的に、その値が`true`である位置を表す`CartesianIndex{N}`のベクトルによるインデックスアクセスと同じです。論理インデックスは、対象となる次元と同じ形状の配列でなければなりません。または、それが唯一のインデックスであり、対象配列を1次元に変形したビューと同じ形状である必要があります。一般には、先に[`findall`](@ref)を呼び出すよりも、真偽値配列をそのままインデックスとして使うほうが効率的です。

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

`N`次元配列への通常のインデックスアクセスでは、ちょうど`N`個のインデックスを使い、各インデックスが対応する次元の位置を選択します。たとえば、3次元配列`A = rand(4, 3, 2)`では、`A[2, 3, 1]`は配列の最初の「ページ」の第2行・第3列にある数を選択します。これは一般に*デカルトインデックスアクセス*と呼ばれます。

#### Linear indexing

インデックス`i`を1つだけ指定すると、そのインデックスは配列の特定の次元の位置を表すものではなくなります。代わりに、配列全体を線形にたどる列優先の反復順序で、第`i`要素を選択します。これは*線形インデックスアクセス*と呼ばれます。実質的には、[`vec`](@ref)で配列を1次元ベクトルに変形したかのように扱います。

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

配列`A`の線形インデックスは、`CartesianIndices(A)[i]`を使って、デカルトインデックスアクセス用の`CartesianIndex`に変換できます（[`CartesianIndices`](@ref)を参照）。また、`N`個のデカルトインデックスの組は、`LinearIndices(A)[i_1, i_2, ..., i_N]`を使って線形インデックスに変換できます（[`LinearIndices`](@ref)を参照）。

```jldoctest linindexing
julia> CartesianIndices(A)[5]
CartesianIndex(2, 2)

julia> LinearIndices(A)[2, 2]
5
```

これらの変換の性能には、方向によって非常に大きな差があることに注意が必要です。線形インデックスからデカルトインデックスの組への変換には除算と剰余の計算が必要ですが、逆方向の変換には乗算と加算しか必要ありません。現代のプロセッサでは、整数除算は乗算より10〜50倍遅い場合があります。[`Array`](@ref)自体のように、線形なメモリ領域を使って実装され、内部で線形インデックスを直接使う配列もあれば、[`Diagonal`](@ref)のように、要素の参照にデカルトインデックスの完全な組を必要とする配列もあります（どちらに該当するかを調べるには、[`IndexStyle`](@ref)を参照してください）。

!!! warning
    配列のすべてのインデックスを反復処理する場合は、`1:length(A)`ではなく[`eachindex(A)`](@ref)を使うほうが適切です。`A`が`IndexCartesian`の場合に高速になるだけでなく、[OffsetArrays](https://github.com/JuliaArrays/OffsetArrays.jl)のような独自のインデックス方式を持つ配列にも対応できます。値だけが必要なら、`for a in A`のように配列自体を直接反復処理するほうが適切です。


#### Omitted and extra indices

線形インデックスアクセスに加え、特定の条件下では、`N`次元配列に対して`N`個より少ない、または多いインデックスを使えます。

インデックスを指定しない末尾の次元がすべて長さ1なら、それらのインデックスを省略できます。つまり、範囲内のアクセスとなるインデックス式において、省略したインデックスが取り得る値が1つしかない場合に限り、末尾のインデックスを省略できます。たとえば、サイズが`(3, 4, 2, 1)`の4次元配列では、省略される第4次元の長さが1なので、3つのインデックスだけでアクセスできます。ただし、この規則よりも線形インデックスアクセスが優先されます。

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

`A[]`で*すべての*インデックスを省略すると、この意味規則により、配列内の唯一の要素を取得すると同時に、要素が1つしかないことも確認できる簡潔なイディオムになります。

同様に、配列の次元数を超えるインデックスがすべて`1`であれば、`N`個より多いインデックスを指定できます。より一般的には、追加の各インデックスが`axes(A, d)`の最初かつ唯一の要素であればよく、ここで`d`は対応する次元番号です。これにより、たとえばベクトルを1列の行列のようにインデックスアクセスできます。

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

配列全体を反復処理するには、次の方法が推奨されます。

```julia
for a in A
    # Do something with the element a
end

for i in eachindex(A)
    # Do something with i and/or A[i]
end
```

最初の形式は、各要素の値が必要で、インデックスは不要な場合に使います。2つ目の形式では、`A`が高速な線形インデックスアクセスを持つ配列型なら、`i`は`Int`になります。それ以外の場合は`CartesianIndex`になります。

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
    `for i = 1:length(A)`とは異なり、[`eachindex`](@ref)を使うと、どの配列型でも効率的に反復処理できます。また、[OffsetArrays](https://github.com/JuliaArrays/OffsetArrays.jl)のように、独自のインデックス方式を持つ汎用的な配列にも対応します。


## Array traits

独自の[`AbstractArray`](@ref)型を作成する場合は、次のようにして、高速な線形インデックスアクセスを持つことを指定できます。

```julia
Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()
```

この設定により、`MyArray`に対する`eachindex`での反復処理には整数が使われます。このトレイトを指定しない場合、デフォルト値`IndexCartesian()`が使われます。

## [Array and Vectorized Operators and Functions](@id man-array-and-vectorized-operators-and-functions)

配列では、次の演算子を使用できます。

1. 単項算術演算 – `-`、`+`
2. 二項算術演算 – `-`、`+`、`*`、`/`、`\`、`^`
3. 比較 – `==`、`!=`、`≈`（[`isapprox`](@ref)）、`≉`

数学的な演算やその他の操作を手軽にベクトル化できるように、Juliaでは[provides the dot syntax](@ref man-vectorized)として`f.(args...)`を使えます。たとえば、`sin.(x)`や`min.(x, y)`により、配列同士、または配列とスカラーを組み合わせて要素ごとの演算（[Broadcasting](@ref)演算）を行えます。さらに、これらはほかのドット呼び出しと組み合わせたときに、1つのループに「融合」されるという利点もあります。たとえば、`sin.(cos.(x))`です。

また、*すべての*二項演算子は[dot version](@ref man-dot-operators)に対応しており、`z .== sin.(x .* y)`のような[fused broadcasting operations](@ref man-vectorized)で、配列（および配列とスカラーの組み合わせ）に適用できます。

`==`のような比較は配列全体に対して行われ、単一の真偽値を返すことに注意してください。要素ごとの比較には、`.==`のようなドット演算子を使います。（`<`のような比較演算では、配列に適用できるのは要素ごとの`.<`形式*だけ*です。）

また、`max.(a,b)`と[`maximum(a)`](@ref)の違いにも注意してください。前者は`a`と`b`に対して、要素ごとに[`max`](@ref)を[`broadcast`](@ref)するのに対し、後者は`a`内の最大値を求めます。`min.(a, b)`と`minimum(a)`の間にも同じ関係が成り立ちます。

## Broadcasting

行列の各列にベクトルを加える場合など、サイズの異なる配列間で要素ごとの二項演算を行いたいことがあります。ベクトルを複製して行列と同じサイズにする方法もありますが、効率的ではありません。

```jldoctest broadcast_example
julia> a = [0.2, 0.5]; A = [1.0 1.6 1.05; 1.07 1.36 1.18];

julia> repeat(a, 1, 3) + A
2×3 Matrix{Float64}:
 1.2   1.8   1.25
 1.57  1.86  1.68
```

各次元のサイズが大きくなると、この方法は無駄が多くなります。そのためJuliaでは、[`broadcast`](@ref)を用意しています。これは追加のメモリを使わずに、配列引数の長さ1の次元をもう一方の配列の対応する次元に合わせて拡張し、指定された関数を要素ごとに適用します。

```jldoctest broadcast_example
julia> broadcast(+, a, A)
2×3 Matrix{Float64}:
 1.2   1.8   1.25
 1.57  1.86  1.68

julia> b = [0.9 0.1]
1×2 Matrix{Float64}:
 0.9  0.1

julia> broadcast(+, a, b)
2×2 Matrix{Float64}:
 1.1  0.3
 1.4  0.6
```

`.+`や`.*`のような[Dotted operators](@ref man-dot-operators)は、`broadcast`の呼び出しと等価です（ただし、[described above](@ref man-array-and-vectorized-operators-and-functions)のとおり、融合される点は異なります）。出力先を明示的に指定する[`broadcast!`](@ref)関数もあります（`.=`による代入を使えば、融合される形でも利用できます）。実際、`f.(args...)`は`broadcast(f, args...)`と等価であり、任意の関数をブロードキャストするための便利な構文になっています（[dot syntax](@ref man-vectorized)）。入れ子になった「ドット呼び出し」`f.(...)`（`.+`などの呼び出しを含む）は、1回の`broadcast`呼び出しに[automatically fuse](@ref man-dot-operators)。

さらに、[`broadcast`](@ref)は配列に限らず、スカラー、タプル、その他のコレクションも扱えます（関数のドキュメントを参照）。デフォルトでスカラーとして扱われるのは一部の引数型だけです。これには、`Number`、`String`、`Symbol`、`Type`、`Function`や、`missing`、`nothing`などの一般的なシングルトンが含まれますが、これらに限りません。それ以外の引数はすべて、要素ごとに反復処理またはインデックスアクセスされます。

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

通常はブロードキャストの対象となるコンテナ（配列など）について、その全要素が反復処理される動作から「保護」したいことがあります。そのコンテナを別のコンテナ（単一要素の[`Tuple`](@ref)など）に入れると、ブロードキャストでは1つの値として扱われます。

```jldoctest
julia> ([1, 2, 3], [4, 5, 6]) .+ ([1, 2, 3],)
([2, 4, 6], [5, 7, 9])

julia> ([1, 2, 3], [4, 5, 6]) .+ tuple([1, 2, 3])
([2, 4, 6], [5, 7, 9])
```

## Implementation

Juliaの配列型の基底となるのは、抽象型[`AbstractArray{T,N}`](@ref)です。この型は、次元数`N`と要素型`T`をパラメータに持ちます。[`AbstractVector`](@ref)と[`AbstractMatrix`](@ref)は、それぞれ1次元と2次元の場合の別名です。`AbstractArray`オブジェクトに対する操作は、高水準の演算子や関数を使い、基盤となる格納方式に依存しない形で定義されています。これらの操作は一般に、個々の配列実装に対するフォールバックとして正しく動作します。

`AbstractArray`型は、広い意味で配列に似たものをすべて含み、その実装は従来の配列と大きく異なる場合があります。たとえば、要素を格納せず、要求されたときに計算することもあります。ただし、具象的な`AbstractArray{T,N}`型は、一般に少なくとも[`size(A)`](@ref)（`Int`タプルを返す）、[`getindex(A, i)`](@ref)、[`getindex(A, i1, ..., iN)`](@ref getindex)を実装するべきです。変更可能な配列では[`setindex!`](@ref)も実装するべきです。これらの操作の時間計算量は、ほぼ定数であることが推奨されます。そうでないと、一部の配列関数が予想外に遅くなる可能性があります。また、具象型では通常、[`similar(A, T=eltype(A), dims=size(A))`](@ref)メソッドも提供するべきです。これは[`copy`](@ref)や、入力を変更せず別の出力を生成するその他の操作で、同種の配列を割り当てるために使われます。`AbstractArray{T,N}`の内部表現にかかわらず、`T`は*整数*によるインデックスアクセス（`A`が空でない場合の`A[1, ..., 1]`）が返すオブジェクトの型であり、`N`は[`size`](@ref)が返すタプルの長さであるべきです。独自の`AbstractArray`実装の定義について詳しくは、[array interface guide in the interfaces chapter](@ref man-interface-array)を参照してください。

`DenseArray`は`AbstractArray`の抽象サブタイプで、要素が列優先順で連続して格納されるすべての配列を含むことを意図しています（[additional notes in Performance Tips](@ref man-performance-column-major)を参照）。[`Array`](@ref)型は`DenseArray`の具体例であり、[`Vector`](@ref)と[`Matrix`](@ref)は、それぞれ1次元と2次元の場合の別名です。すべての`AbstractArray`で必要とされる操作以外に、`Array`専用に実装されている操作はごくわずかです。配列ライブラリの大部分は、どの独自配列でも同じように動作できる汎用的な方法で実装されています。

`SubArray`は`AbstractArray`の特殊化であり、元の配列をコピーするのではなく、そのメモリを共有してインデックスアクセスを行います。`SubArray`は[`view`](@ref)関数で作成します。この関数は[`getindex`](@ref)と同じように、配列と一連のインデックス引数を渡して呼び出します。[`view`](@ref)の結果は[`getindex`](@ref)の結果と同じように見えますが、データは元の場所に残ります。[`view`](@ref)は、入力のインデックスベクトルを`SubArray`オブジェクトに格納し、後でそれを使って元の配列に間接的にインデックスアクセスできるようにします。式またはコードブロックの前に[`@views`](@ref)マクロを置くと、その式の中のすべての`array[...]`スライスが、代わりに`SubArray`ビューを作成するように変換されます。

[`BitArray`](@ref)は、真偽値1つにつき1ビットで格納する、メモリ効率のよい「パックされた」真偽値配列です。真偽値1つにつき1バイトを使う`Array{Bool}`配列と同様に使用でき、`Array(bitarray)`で後者から前者へ、`BitArray(array)`で前者から後者へ変換できます。

要素間の間隔（ストライド）が明確に定まった形でメモリに格納されている配列を、「ストライド付き」の配列と呼びます。対応する要素型を持つストライド付き配列は、その[`pointer`](@ref)と各次元のストライドを渡すだけで、BLASやLAPACKのような外部（Julia以外）のライブラリに渡せます。[`stride(A, d)`](@ref)は、第`d`次元に沿った要素間の距離です。たとえば、`rand(5,7,2)`が返す組み込みの`Array`では、要素が列優先順で連続して配置されています。したがって、第1次元のストライド、つまり同じ列の要素間の間隔は`1`です。

```jldoctest strides
julia> A = rand(5, 7, 2);

julia> stride(A, 1)
1
```

第2次元のストライドは、同じ行の要素間の間隔です。この移動では、1列に含まれる要素数（`5`）だけ進みます。同様に、第3次元の2つの「ページ」間を移動するには、`5*7 == 35`要素分だけ進む必要があります。この配列の[`strides`](@ref)は、この3つの数をまとめたタプルです。

```jldoctest strides
julia> strides(A)
(1, 5, 35)
```

この例では、*メモリ上で*進む要素数と、*線形インデックス*の増分が一致します。これは`Array`（およびその他の`DenseArray`のサブタイプ）のような連続配列でのみ成り立ち、一般には成り立ちません。範囲インデックスを使ったビューは、*非連続な*ストライド付き配列のよい例です。`V = @view A[1:3:4, 2:2:6, 2:-1:1]`を考えてみましょう。このビュー`V`は`A`と同じメモリを参照しますが、一部の要素を飛ばしたり、順序を入れ替えたりしています。元の配列から3行ごとに選択しているため、`V`の第1次元のストライドは`3`です。

```jldoctest strides
julia> V = @view A[1:3:4, 2:2:6, 2:-1:1];

julia> stride(V, 1)
3
```

同様に、このビューは元の`A`から1列おきに選択しています。そのため、第2次元で隣のインデックスへ移動するときは、5要素からなる列2つ分だけ進む必要があります。

```jldoctest strides
julia> stride(V, 2)
10
```

第3次元は、順序が逆になっている点が特徴的です。最初の「ページ」から2番目のページへ移動するには、メモリ上を*逆方向に*進まなければならないため、この次元のストライドは負になります。

```jldoctest strides
julia> stride(V, 3)
-35
```

つまり、`V`の`pointer`は、実際には`A`のメモリブロックの途中を指しており、そこからメモリ上の前後両方向にある要素を参照します。独自のストライド付き配列の定義について詳しくは、[interface guide for strided arrays](@ref man-interface-strided-arrays)を参照してください。[`StridedVector`](@ref)と[`StridedMatrix`](@ref)は、ストライド付き配列とみなされる多くの組み込み配列型をまとめる便利な別名です。これらにより、ポインタとストライドだけを使って、高度に調整・最適化されたBLASやLAPACKの関数を呼び出す専用の実装へディスパッチできます。

ストライドが表すのはインデックスではなく、メモリ上のオフセットであることを強調しておきます。線形（単一インデックス）アクセスとデカルト（複数インデックス）アクセスの間で変換したい場合は、[`LinearIndices`](@ref)と[`CartesianIndices`](@ref)を参照してください。

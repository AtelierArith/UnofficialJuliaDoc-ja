# Interfaces

Julia の強力さと拡張性の多くは、いくつもの非公式なインターフェースによって実現されています。特定のメソッドをいくつか拡張してカスタム型に対応させると、その型のオブジェクトはそれらの機能を利用できるだけでなく、そうした振る舞いを汎用的に利用するよう書かれた他のメソッドでも使えるようになります。

## [Iteration](@id man-interface-iteration)

必ず定義しなければならないメソッドは2つあります。

| 必須メソッド                  | 簡単な説明                                              |
|:----------------------- |:-------------------------------------------------- |
| [`iterate(iter)`](@ref) | 最初の要素と初期状態のタプルを返します。空の場合は [`nothing`](@ref) を返します。 |
| `iterate(iter, state)`  | 次の要素と次の状態のタプルを返します。要素が残っていない場合は `nothing` を返します。   |

状況に応じて定義すべきメソッドが、ほかにもいくつかあります。`Base.IteratorSize(IterType)` のデフォルト定義は `Base.HasLength()` なので、`Base.IteratorSize(IterType)` と `length(iter)` の少なくとも一方は必ず定義してください。

| メソッド                                    | このメソッドを定義すべき状況                                                            | デフォルト定義            | 簡単な説明                                                                                                             |
|:--------------------------------------- |:------------------------------------------------------------------------- |:------------------ |:----------------------------------------------------------------------------------------------------------------- |
| [`Base.IteratorSize(IterType)`](@ref)   | デフォルトの動作が適切でない場合                                                          | `Base.HasLength()` | 状況に応じて `Base.HasLength()`、`Base.HasShape{N}()`、`Base.IsInfinite()`、または `Base.SizeUnknown()` のいずれか                 |
| [`length(iter)`](@ref)                  | `Base.IteratorSize()` が `Base.HasLength()` または `Base.HasShape{N}()` を返す場合 | (*undefined*)      | 分かっている場合は要素数                                                                                                      |
| [`size(iter, [dim])`](@ref)             | `Base.IteratorSize()` が `Base.HasShape{N}()` を返す場合                        | (*undefined*)      | 分かっている場合は各次元の要素数                                                                                                  |
| [`Base.IteratorEltype(IterType)`](@ref) | デフォルトの動作が適切でない場合                                                          | `Base.HasEltype()` | 状況に応じて `Base.EltypeUnknown()` または `Base.HasEltype()` のいずれか                                                        |
| [`eltype(IterType)`](@ref)              | デフォルトの動作が適切でない場合                                                          | `Any`              | `iterate()` が返すタプルの最初の要素の型                                                                                        |
| [`Base.isdone(iter, [state])`](@ref)    | イテレータが状態を持つ場合は**必須**                                                      | `missing`          | イテレーション完了を判定するための高速経路のヒントです。状態を持つイテレータでこれを定義しないと、`isempty()` や `zip()` のように完了状態を確認する関数がイテレータを変更し、バグを引き起こすことがあります。 |

逐次イテレーションは [`iterate`](@ref) 関数によって実装されます。Julia のイテレータは、反復中にオブジェクトを変更する代わりに、オブジェクトの外部でイテレーション状態を管理できます。iterate の戻り値は、値と状態のタプルか、要素が残っていないことを示す `nothing` のいずれかです。状態オブジェクトは次の反復時に iterate 関数へ渡されます。通常、これは反復可能オブジェクトの実装詳細であり、外部からは参照されません。

この関数を定義するオブジェクトはすべて反復可能であり、[many functions that rely upon iteration](@ref lib-collections-iteration) で使用できます。また、次の構文を使えば、[`for`](@ref) ループでも直接使用できます。

```julia
for item in iter   # or  "for item = iter"
    # body
end
```

これは次のように変換されます。

```julia
next = iterate(iter)
while next !== nothing
    (item, state) = next
    # body
    next = iterate(iter, state)
end
```

簡単な例として、長さが定義された、平方数からなる反復可能な列を考えてみましょう。

```jldoctest squaretype
julia> struct Squares
           count::Int
       end

julia> Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
```

[`iterate`](@ref) を定義するだけで、`Squares` 型はすでにかなり強力です。すべての要素を反復できます。

```jldoctest squaretype
julia> for item in Squares(7)
           println(item)
       end
1
4
9
16
25
36
49
```

[`in`](@ref) や [`sum`](@ref) など、反復可能オブジェクトに使える組み込みメソッドも多数利用できます。

```jldoctest squaretype
julia> 25 in Squares(10)
true

julia> sum(Squares(100))
338350
```

この反復可能なコレクションについてJuliaにさらに情報を伝えるため、拡張できるメソッドがいくつかあります。`Squares` の列の要素は常に `Int` であることが分かっています。[`eltype`](@ref) メソッドを拡張すれば、その情報をJuliaに伝え、より複雑なメソッドで特殊化されたコードを生成できるようになります。また、列の要素数も分かっているので、[`length`](@ref) も拡張できます。

```jldoctest squaretype
julia> Base.eltype(::Type{Squares}) = Int # Note that this is defined for the type

julia> Base.length(S::Squares) = S.count
```

これで、Juliaにすべての要素を配列に [`collect`](@ref) するよう指示すると、各要素を `Vector{Any}` に素朴に [`push!`](@ref) していく代わりに、適切なサイズの `Vector{Int}` を事前に確保できます。

```jldoctest squaretype
julia> collect(Squares(4))
4-element Vector{Int64}:
  1
  4
  9
 16
```

汎用実装を利用することもできますが、より単純なアルゴリズムが分かっている場合は、特定のメソッドを拡張することもできます。たとえば、平方和を計算する公式があるので、汎用的な反復処理を、より高速な実装で置き換えられます。

```jldoctest squaretype
julia> Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)

julia> sum(Squares(1803))
1955361914
```

これはJulia Base全体でよく見られるパターンです。少数の必須メソッドで非公式なインターフェースを定義し、それを基盤として多くの高度な振る舞いを実現します。型によっては、特定のケースでより効率的なアルゴリズムを使えると分かっている場合に、こうした追加の振る舞いも特殊化するとよいでしょう。

コレクションを逆順に反復するには、[`Iterators.reverse(iterator)`](@ref) を反復する方法もよく使われます。ただし、逆順の反復を実際にサポートするには、イテレータ型 `T` が `Iterators.Reverse{T}` に対する `iterate` を実装する必要があります。（`r::Iterators.Reverse{T}` の場合、基になるイテレータの型 `T` は `r.itr` です。）先ほどの `Squares` の例では、次の `Iterators.Reverse{Squares}` メソッドを実装します。

```jldoctest squaretype
julia> Base.iterate(rS::Iterators.Reverse{Squares}, state=rS.itr.count) = state < 1 ? nothing : (state*state, state-1)

julia> collect(Iterators.reverse(Squares(4)))
4-element Vector{Int64}:
 16
  9
  4
  1
```

## Indexing

| 実装するメソッド             | 簡単な説明                                          |
|:-------------------- |:---------------------------------------------- |
| `getindex(X, i)`     | `X[i]`、インデックスアクセス。スカラーでない `i` はコピーを確保する必要があります |
| `setindex!(X, v, i)` | `X[i] = v`、インデックスによる代入                         |
| `firstindex(X)`      | 最初のインデックス。`X[begin]` で使用します                    |
| `lastindex(X)`       | 最後のインデックス。`X[end]` で使用します                      |

上記の `Squares` 反復可能オブジェクトでは、列の `i` 番目の要素を二乗するだけで簡単に計算できます。これをインデックス式 `S[i]` として公開できます。この動作を有効にするには、`Squares` で [`getindex`](@ref) を定義するだけです。

```jldoctest squaretype
julia> function Base.getindex(S::Squares, i::Int)
           1 <= i <= S.count || throw(BoundsError(S, i))
           return i*i
       end

julia> Squares(100)[23]
529
```

さらに、`S[begin]` と `S[end]` という構文をサポートするには、それぞれ最初と最後の有効なインデックスを指定する [`firstindex`](@ref) と [`lastindex`](@ref) を定義する必要があります。

```jldoctest squaretype
julia> Base.firstindex(S::Squares) = 1

julia> Base.lastindex(S::Squares) = length(S)

julia> Squares(23)[end]
529
```

たとえば `a[3, begin, 7]` のような、多次元の `begin`/`end` インデックスアクセスでは、`firstindex(a, dim)` と `lastindex(a, dim)` を定義してください。これらはデフォルトで、それぞれ `axes(a, dim)` に対して `first` と `last` を呼び出します。

ただし、上記で定義されるのは、整数インデックスを1つ取る [`getindex`](@ref) だけです。`Int` 以外でインデックスアクセスすると、一致するメソッドがないことを示す [`MethodError`](@ref) がスローされます。範囲や `Int` のベクトルによるインデックスアクセスをサポートするには、別途メソッドを定義する必要があります。

```jldoctest squaretype
julia> Base.getindex(S::Squares, i::Number) = S[convert(Int, i)]

julia> Base.getindex(S::Squares, I) = [S[i] for i in I]

julia> Squares(10)[[3,4.,5]]
3-element Vector{Int64}:
  9
 16
 25
```

[indexing operations supported by some of the builtin types](@ref man-array-indexing) の機能をさらにサポートできるようになってきましたが、まだ多くの振る舞いが不足しています。振る舞いを追加するにつれて、この `Squares` の列は、ますますベクトルに似てきました。これらの振る舞いをすべて自分で定義する代わりに、[`AbstractArray`](@ref) のサブタイプとして正式に定義できます。

## [Abstract Arrays](@id man-interface-array)

| 実装するメソッド                                 |                                      | 簡単な説明                                                                                                                  |
|:---------------------------------------- |:------------------------------------ |:---------------------------------------------------------------------------------------------------------------------- |
| `size(A)`                                |                                      | `A` の次元を含むタプルを返します                                                                                                     |
| `getindex(A, i::Int)`                    |                                      | （`IndexLinear` の場合）線形スカラーインデックスアクセス                                                                                    |
| `getindex(A, I::Vararg{Int, N})`         |                                      | （`IndexCartesian` の場合。ここで `N = ndims(A)`）N次元スカラーインデックスアクセス                                                             |
| **任意のメソッド**                              | **デフォルト定義**                          | **簡単な説明**                                                                                                              |
| `IndexStyle(::Type)`                     | `IndexCartesian()`                   | `IndexLinear()` または `IndexCartesian()` のいずれかを返します。詳しくは以下の説明を参照してください。                                                  |
| `setindex!(A, v, i::Int)`                |                                      | （`IndexLinear` の場合）スカラーのインデックス代入                                                                                       |
| `setindex!(A, v, I::Vararg{Int, N})`     |                                      | （`IndexCartesian` の場合。ここで `N = ndims(A)`）N次元スカラーのインデックス代入                                                              |
| `getindex(A, I...)`                      | スカラー `getindex` に基づいて定義              | [Multidimensional and nonscalar indexing](@ref man-array-indexing)                                                     |
| `setindex!(A, X, I...)`                  | スカラー `setindex!` に基づいて定義             | [Multidimensional and nonscalar indexed assignment](@ref man-array-indexing)                                           |
| `iterate`                                | スカラー `getindex` に基づいて定義              | イテレーション                                                                                                                |
| `length(A)`                              | `prod(size(A))`                      | 要素数                                                                                                                    |
| `similar(A)`                             | `similar(A, eltype(A), size(A))`     | 同じ形状と要素型を持つ可変配列を返します                                                                                                   |
| `similar(A, ::Type{S})`                  | `similar(A, S, size(A))`             | 同じ形状で、指定された要素型を持つ可変配列を返します                                                                                             |
| `similar(A, dims::Dims)`                 | `similar(A, eltype(A), dims)`        | 同じ要素型で、サイズが *dims* の可変配列を返します                                                                                          |
| `similar(A, ::Type{S}, dims::Dims)`      | `Array{S}(undef, dims)`              | 指定された要素型とサイズを持つ可変配列を返します                                                                                               |
| **非標準インデックス**                            | **デフォルト定義**                          | **簡単な説明**                                                                                                              |
| `axes(A)`                                | `map(OneTo, size(A))`                | 有効なインデックスの `AbstractUnitRange{<:Integer}` のタプルを返します。各軸はそれ自体の軸である必要があり、つまり `axes.(axes(A),1) == axes(A)` が満たされる必要があります。 |
| `similar(A, ::Type{S}, inds)`            | `similar(A, S, Base.to_shape(inds))` | 指定されたインデックス `inds` を持つ可変配列を返します（下記参照）。                                                                                 |
| `similar(T::Union{Type,Function}, inds)` | `T(Base.to_shape(inds))`             | 指定されたインデックス `inds` を持つ、`T` に類似した配列を返します（下記参照）。                                                                         |

型を `AbstractArray` のサブタイプとして定義すると、単一要素へのアクセスを基盤とするイテレーションや多次元インデックスアクセスなど、豊富な振る舞いを多数継承します。サポートされるメソッドについては、[arrays manual page](@ref man-multi-dim-arrays) と [Julia Base section](@ref lib-arrays) を参照してください。

`AbstractArray` のサブタイプを定義するうえで重要なのが、[`IndexStyle`](@ref) です。インデックスアクセスは配列の重要な機能であり、ホットループ内で頻繁に行われるため、インデックスアクセスとインデックス代入の両方をできるだけ効率的にすることが重要です。配列のデータ構造は通常、次の2通りのいずれかで定義されます。要素へのアクセスに1つのインデックスだけを使うのが最も効率的なもの（線形インデックスアクセス）と、各次元に対応するインデックスを使って要素にアクセスするものです。Juliaでは、この2つの方式をそれぞれ `IndexLinear()` と `IndexCartesian()` として識別します。線形インデックスを複数のインデックス添字に変換する処理は通常非常に高コストです。そのため、トレイトに基づくこの仕組みによって、すべての配列型で効率的な汎用コードを実現できます。

この違いによって、型が定義すべきスカラーインデックスアクセス用メソッドが決まります。`IndexLinear()` 配列は単純で、`getindex(A::ArrayType, i::Int)` を定義するだけです。その後、配列に複数次元のインデックスを指定してアクセスすると、フォールバックの `getindex(A::AbstractArray, I...)` がインデックスを効率的に1つの線形インデックスに変換し、上記のメソッドを呼び出します。一方、`IndexCartesian()` 配列では、サポートする次元数ごとに、`ndims(A)` 個の `Int` インデックスを取るメソッドを定義する必要があります。たとえば、標準ライブラリモジュール `SparseArrays` の [`SparseMatrixCSC`](@ref) は2次元しかサポートしないため、`getindex(A::SparseMatrixCSC, i::Int, j::Int)` だけを定義しています。[`setindex!`](@ref) も同様です。

先ほどの平方数の列に戻り、代わりに `AbstractArray{Int, 1}` のサブタイプとして定義してみましょう。

```jldoctest squarevectype
julia> struct SquaresVector <: AbstractArray{Int, 1}
           count::Int
       end

julia> Base.size(S::SquaresVector) = (S.count,)

julia> Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()

julia> Base.getindex(S::SquaresVector, i::Int) = i*i
```

`AbstractArray` の2つのパラメーターを指定することが非常に重要です。1つ目は [`eltype`](@ref) を、2つ目は [`ndims`](@ref) を定義します。このスーパータイプと3つのメソッドだけで、`SquaresVector` は反復可能で、インデックスアクセスが可能な、完全に機能する配列になります。

```jldoctest squarevectype
julia> s = SquaresVector(4)
4-element SquaresVector:
  1
  4
  9
 16

julia> s[s .> 8]
2-element Vector{Int64}:
  9
 16

julia> s + s
4-element Vector{Int64}:
  2
  8
 18
 32

julia> sin.(s)
4-element Vector{Float64}:
  0.8414709848078965
 -0.7568024953079282
  0.4121184852417566
 -0.2879033166650653
```

より複雑な例として、[`Dict`](@ref) を基盤に、簡易的なN次元疎配列型を独自に定義してみましょう。

```jldoctest squarevectype
julia> struct SparseArray{T,N} <: AbstractArray{T,N}
           data::Dict{NTuple{N,Int}, T}
           dims::NTuple{N,Int}
       end

julia> SparseArray(::Type{T}, dims::Int...) where {T} = SparseArray(T, dims);

julia> SparseArray(::Type{T}, dims::NTuple{N,Int}) where {T,N} = SparseArray{T,N}(Dict{NTuple{N,Int}, T}(), dims);

julia> Base.size(A::SparseArray) = A.dims

julia> Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where {T} = SparseArray(T, dims)

julia> Base.getindex(A::SparseArray{T,N}, I::Vararg{Int,N}) where {T,N} = get(A.data, I, zero(T))

julia> Base.setindex!(A::SparseArray{T,N}, v, I::Vararg{Int,N}) where {T,N} = (A.data[I] = v)
```

これは `IndexCartesian` 配列なので、配列の次元数に応じて [`getindex`](@ref) と [`setindex!`](@ref) を手動で定義する必要があります。`SquaresVector` とは異なり、[`setindex!`](@ref) を定義できるため、配列を変更できます。

```jldoctest squarevectype
julia> A = SparseArray(Float64, 3, 3)
3×3 SparseArray{Float64, 2}:
 0.0  0.0  0.0
 0.0  0.0  0.0
 0.0  0.0  0.0

julia> fill!(A, 2)
3×3 SparseArray{Float64, 2}:
 2.0  2.0  2.0
 2.0  2.0  2.0
 2.0  2.0  2.0

julia> A[:] = 1:length(A); A
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
```

`AbstractArray` のインデックスアクセス結果は、それ自体が配列になることがあります（たとえば `AbstractRange` によるインデックスアクセスの場合）。`AbstractArray` のフォールバックメソッドは [`similar`](@ref) を使って、適切なサイズと要素型の `Array` を確保し、上記の基本的なインデックスアクセスメソッドを使って値を埋めます。しかし、配列ラッパーを実装する場合は、結果もラップしたいことがよくあります。

```jldoctest squarevectype
julia> A[1:2,:]
2×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
```

この例では、適切なラップ済み配列を作成する `Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where T` を定義して実現しています。（`similar` は1引数形式と2引数形式もサポートしますが、ほとんどの場合、特殊化が必要なのは3引数形式だけです。）これを機能させるには、`SparseArray` が可変であり、`setindex!` をサポートしていることが重要です。`SparseArray` に対して `similar`、`getindex`、`setindex!` も定義すると、配列を [`copy`](@ref) できるようになります。

```jldoctest squarevectype
julia> copy(A)
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
```

上記の反復可能・インデックス可能なメソッドに加えて、これらの型は互いに連携し、Julia Baseで `AbstractArrays` 向けに定義されているほとんどのメソッドを利用できます。

```jldoctest squarevectype
julia> A[SquaresVector(3)]
3-element SparseArray{Float64, 1}:
 1.0
 4.0
 9.0

julia> sum(A)
45.0
```

非標準インデックス（1以外から始まるインデックス）を許す配列型を定義する場合は、[`axes`](@ref) を特殊化してください。また、`dims` 引数（通常はサイズを表す `Dims` タプル）が `AbstractUnitRange` オブジェクトを受け取れるように、[`similar`](@ref) も特殊化してください。たとえば、独自に設計した範囲型 `Ind` を受け取れるようにできます。詳しくは [Arrays with custom indices](@ref man-custom-indices) を参照してください。

## [Strided Arrays](@id man-interface-strided-arrays)

| 実装するメソッド                                 |                 | 簡単な説明                                                                         |
|:---------------------------------------- |:--------------- |:----------------------------------------------------------------------------- |
| `strides(A)`                             |                 | 各次元で隣接する要素間のメモリ上の距離（要素数）をタプルで返します。`A` が `AbstractArray{T,0}` の場合は、空のタプルを返します。 |
| `Base.unsafe_convert(::Type{Ptr{T}}, A)` |                 | 配列のネイティブアドレスを返します。                                                            |
| `Base.elsize(::Type{<:A})`               |                 | 配列内の連続する要素間のストライド（バイト数）を返します。                                                 |
| **任意のメソッド**                              | **デフォルト定義**     | **簡単な説明**                                                                     |
| `stride(A, i::Int)`                      | `strides(A)[i]` | 次元 i で隣接する要素間のメモリ上の距離（要素数）を返します。                                              |

ストライド配列は `AbstractArray` のサブタイプで、要素が固定ストライドでメモリに格納されています。配列の要素型がBLASと互換性を持つ場合、ストライド配列はBLASやLAPACKのルーチンを利用して、線形代数演算をより効率的に実行できます。ユーザー定義のストライド配列の典型例は、標準の `Array` を追加の構造でラップしたものです。

警告：基になるストレージが実際にはストライド配列でない場合、これらのメソッドを実装しないでください。誤った結果やセグメンテーション違反につながる可能性があります。

次の関数は、ストライド配列 `A` のインデックス `I` にある要素へアクセスする方法を示します。この関数は、要素型が `isbitstype` であり、インデックスが範囲内にあることを前提としています。

```jldoctest
julia> function unsafe_strided_getindex(A::AbstractArray{T,N}, I::Vararg{Int, N})::T where {T, N}
           A_cconv = Base.cconvert(Ptr{T}, A)
           GC.@preserve A_cconv begin
               A_ptr = Base.unsafe_convert(Ptr{T}, A_cconv)
               for d in 1:N
                   stride_in_bytes = stride(A, d) * Base.elsize(typeof(A))
                   first_idx = first(axes(A, d))
                   A_ptr += (I[d] - first_idx) * stride_in_bytes
               end
               unsafe_load(A_ptr)
           end
       end;

julia> A = [1 5; 2 6; 3 7; 4 8];

julia> unsafe_strided_getindex(A, 3, 2)
7

julia> V = view(A, 1:2:3, 1:2);

julia> unsafe_strided_getindex(V, 2, 2)
7
```

以下に、ストライド配列となる配列型と、そうでない配列型の例を示します。

```julia
1:5   # not strided (there is no storage associated with this array.)
Vector(1:5)  # is strided with strides (1,)
A = [1 5; 2 6; 3 7; 4 8]  # is strided with strides (1,4)
V = view(A, 1:2, :)   # is strided with strides (1,4)
V = view(A, 1:2:3, 1:2)   # is strided with strides (2,4)
V = view(A, [1,2,4], :)   # is not strided, as the spacing between rows is not fixed.
```

## [Customizing broadcasting](@id man-interfaces-broadcasting)

| 実装するメソッド                                                   | 簡単な説明                                          |
|:---------------------------------------------------------- |:---------------------------------------------- |
| `Base.BroadcastStyle(::Type{SrcType}) = SrcStyle()`        | `SrcType` のブロードキャスト動作                          |
| `Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})` | 出力コンテナーの確保                                     |
| **任意のメソッド**                                                |                                                |
| `Base.BroadcastStyle(::Style1, ::Style2) = Style12()`      | スタイルを混在させる場合の優先順位規則                            |
| `Base.axes(x)`                                             | `x` のインデックスを、[`axes(x)`](@ref) に従って宣言します。      |
| `Base.broadcastable(x)`                                    | `x` を、`axes` を持ち、インデックスアクセスをサポートするオブジェクトに変換します |
| **デフォルトの仕組みを迂回する場合**                                       |                                                |
| `Base.copy(bc::Broadcasted{DestStyle})`                    | `broadcast` のカスタム実装                            |
| `Base.copyto!(dest, bc::Broadcasted{DestStyle})`           | `broadcast!` のカスタム実装。`DestStyle` に特殊化します       |
| `Base.copyto!(dest::DestType, bc::Broadcasted{Nothing})`   | `broadcast!` のカスタム実装。`DestType` に特殊化します        |
| `Base.Broadcast.broadcasted(f, args...)`                   | 融合式内のデフォルトの遅延動作を上書きします                         |
| `Base.Broadcast.instantiate(bc::Broadcasted{DestStyle})`   | 遅延ブロードキャストの軸の計算を上書きします                         |

[Broadcasting](@ref) は、`broadcast` または `broadcast!` の明示的な呼び出しによって、あるいは `A .+ b` や `f.(x, y)` などの「ドット」演算によって暗黙的に実行されます。[`axes`](@ref) を持ち、インデックスアクセスをサポートするオブジェクトは、ブロードキャストの引数として使用できます。デフォルトでは、結果は `Array` に格納されます。この基本的な仕組みは、主に次の3つの方法で拡張できます。

  * すべての引数がブロードキャストをサポートするようにする
  * 与えられた引数の組に適した出力配列を選択する
  * 与えられた引数の組に対して効率的な実装を選択する

すべての型が `axes` とインデックスアクセスをサポートするわけではありませんが、ブロードキャストで使えると便利な型は多数あります。[`Base.broadcastable`](@ref) 関数はブロードキャスト対象の各引数に対して呼び出され、`axes` とインデックスアクセスをサポートする別のオブジェクトを返すことができます。デフォルトでは、すべての `AbstractArray` と `Number` に対して恒等関数となります。これらはすでに `axes` とインデックスアクセスをサポートしているためです。

型をブロードキャストにおいてコンテナーではなく「0次元スカラー」（単一のオブジェクト）として扱いたい場合は、次のメソッドを定義してください。

```julia
Base.broadcastable(o::MyType) = Ref(o)
```

このメソッドは、引数を0次元の [`Ref`](@ref) コンテナーに包んで返します。たとえば、型そのもの、関数、[`missing`](@ref) や [`nothing`](@ref) のような特殊なシングルトン、日付型に対して、このようなラッパーメソッドが定義されています。

カスタムの配列風型では、`Base.broadcastable` を特殊化して形状を定義できます。ただし、`collect(Base.broadcastable(x)) == collect(x)` という規約に従ってください。例外として、`AbstractString` があります。文字列は文字の反復可能なコレクションですが、ブロードキャストではスカラーとして扱われるよう特別に処理されます。詳しくは [Strings](@ref) を参照してください。

次の2つの段階（出力配列と実装の選択）は、与えられた引数の組に対して1つの答えを決めることに依存します。ブロードキャストでは、引数のさまざまな型を1つの出力配列と1つの実装に集約する必要があります。この単一の答えを、ブロードキャストでは「スタイル」と呼びます。ブロードキャスト可能なオブジェクトはそれぞれ独自の優先スタイルを持ち、型昇格に似た仕組みでそれらを1つの答え、つまり「出力先スタイル」にまとめます。

### Broadcast Styles

`Base.BroadcastStyle` は、すべてのブロードキャストスタイルの基底となる抽象型です。関数として使う場合は、単項形式（引数1つ）と二項形式の2種類があります。単項形式は、特定のブロードキャスト動作や出力型を実装する意図があり、デフォルトのフォールバックである [`Broadcast.DefaultArrayStyle`](@ref) に依存しないことを示します。

これらのデフォルト動作を上書きするには、オブジェクトに対してカスタムの `BroadcastStyle` を定義します。

```julia
struct MyStyle <: Broadcast.BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyType}) = MyStyle()
```

場合によっては、`MyStyle` を定義せずに済ませたいこともあるでしょう。その場合は、汎用ブロードキャストラッパーを利用できます。

  * 任意の型には `Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.Style{MyType}()` を使用できます。
  * `MyType` が `AbstractArray` の場合は、`Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.ArrayStyle{MyType}()` が適しています。
  * 特定の次元数だけをサポートする `AbstractArrays` には、`Broadcast.AbstractArrayStyle{N}` のサブタイプを作成します（下記参照）。

ブロードキャスト演算に複数の引数が含まれる場合、各引数のスタイルを組み合わせて、出力コンテナーの型を決める単一の `DestStyle` を決定します。詳しくは [below](@ref writing-binary-broadcasting-rules) を参照してください。

### Selecting an appropriate output array

ディスパッチと特殊化を可能にするため、ブロードキャスト演算ごとにブロードキャストスタイルが計算されます。結果配列の実際の確保は `similar` が行い、Broadcasted オブジェクトを第1引数として受け取ります。

```julia
Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})
```

フォールバック定義は次のとおりです。

```julia
similar(bc::Broadcasted{DefaultArrayStyle{N}}, ::Type{ElType}) where {N,ElType} =
    similar(Array{ElType}, axes(bc))
```

必要に応じて、これらの引数の一部またはすべてに対して特殊化できます。最後の引数 `bc` は、（融合されている可能性のある）ブロードキャスト演算を遅延的に表現する `Broadcasted` オブジェクトです。この用途で特に重要なラッパーのフィールドは、関数と引数リストをそれぞれ表す `f` と `args` です。引数リストには、別の `Broadcasted` ラッパーが入れ子になって含まれることもよくあります。

具体例として、配列と1文字を格納する `ArrayAndChar` 型を作成したとします。

```jldoctest ArrayAndChar; output = false
struct ArrayAndChar{T,N} <: AbstractArray{T,N}
    data::Array{T,N}
    char::Char
end
Base.size(A::ArrayAndChar) = size(A.data)
Base.getindex(A::ArrayAndChar{T,N}, inds::Vararg{Int,N}) where {T,N} = A.data[inds...]
Base.setindex!(A::ArrayAndChar{T,N}, val, inds::Vararg{Int,N}) where {T,N} = A.data[inds...] = val
Base.showarg(io::IO, A::ArrayAndChar, toplevel) = print(io, typeof(A), " with char '", A.char, "'")
# output

```

ブロードキャスト後も `char` の「メタデータ」を保持したいとします。まず、次を定義します。

```jldoctest ArrayAndChar; output = false
Base.BroadcastStyle(::Type{<:ArrayAndChar}) = Broadcast.ArrayStyle{ArrayAndChar}()
# output

```

このため、対応する `similar` メソッドも定義する必要があります。

```jldoctest ArrayAndChar; output = false
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{ArrayAndChar}}, ::Type{ElType}) where ElType
    # Scan the inputs for the ArrayAndChar:
    A = find_aac(bc)
    # Use the char field of A to create the output
    ArrayAndChar(similar(Array{ElType}, axes(bc)), A.char)
end

"`A = find_aac(As)` returns the first ArrayAndChar among the arguments."
find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)
find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
find_aac(x) = x
find_aac(::Tuple{}) = nothing
find_aac(a::ArrayAndChar, rest) = a
find_aac(::Any, rest) = find_aac(rest)
# output
find_aac (generic function with 6 methods)
```

これらの定義により、次のように動作します。

```jldoctest ArrayAndChar
julia> a = ArrayAndChar([1 2; 3 4], 'x')
2×2 ArrayAndChar{Int64, 2} with char 'x':
 1  2
 3  4

julia> a .+ 1
2×2 ArrayAndChar{Int64, 2} with char 'x':
 2  3
 4  5

julia> a .+ [5,10]
2×2 ArrayAndChar{Int64, 2} with char 'x':
  6   7
 13  14
```

### [Extending broadcast with custom implementations](@id extending-in-place-broadcast)

一般に、ブロードキャスト演算は、適用する関数とその引数を保持する遅延評価の `Broadcasted` コンテナーで表されます。引数自体がさらに入れ子になった `Broadcasted` コンテナーである場合もあり、評価対象となる大きな式木を形成します。入れ子になった `Broadcasted` コンテナーの木は、ドット構文によって暗黙的に構築されます。たとえば、`5 .+ 2.*x` は一時的に `Broadcasted(+, 5, Broadcasted(*, 2, x))` で表されます。これは `copy` の呼び出しによってすぐに実体化されるため、ユーザーからは見えません。しかし、このコンテナーこそが、カスタム型の作者にとってブロードキャストを拡張する基盤となります。その後、組み込みのブロードキャスト機構が引数に基づいて結果の型とサイズを決定し、領域を確保してから、デフォルトの `copyto!(::AbstractArray, ::Broadcasted)` メソッドを使って `Broadcasted` オブジェクトの実体化結果をコピーします。組み込みのフォールバックである `broadcast` と `broadcast!` も同様に、演算を一時的な `Broadcasted` 表現として構築し、同じコードパスを通ります。これにより、カスタム配列の実装で独自の `copyto!` を特殊化し、ブロードキャストをカスタマイズして最適化できます。これは計算されたブロードキャストスタイルによって決まります。このスタイルは演算において非常に重要なため、ディスパッチと特殊化ができるよう、`Broadcasted` 型の最初の型パラメーターとして格納されています。

型によっては、ブロードキャストの入れ子になった階層をまたいで演算を「融合」する仕組みが利用できない場合や、段階的に評価したほうが効率的な場合があります。そのような場合は、`x .* (x .+ 1)` を、内側の演算を先に評価してから外側の演算に取りかかる `broadcast(*, x, broadcast(+, x, 1))` と書いた場合のように評価したいことがあります。このような先行評価は、間接化によって直接サポートされています。Juliaは `Broadcasted` オブジェクトを直接構築する代わりに、融合式 `x .* (x .+ 1)` を `Broadcast.broadcasted(*, x, Broadcast.broadcasted(+, x, 1))` に変換します。デフォルトでは、`broadcasted` は `Broadcasted` コンストラクターを呼び出して、融合式木の遅延表現を作成します。ただし、特定の関数と引数の組み合わせに対して、これを上書きできます。

たとえば、組み込みの `AbstractRange` オブジェクトはこの仕組みを使い、ブロードキャスト式のうち、各要素を計算せずに開始値、刻み幅、長さ（または終端値）だけから先行評価できる部分を最適化します。他の仕組みと同様に、`broadcasted` も引数のブロードキャストスタイルを組み合わせて計算し、それを公開します。そのため、`broadcasted(f, args...)` ではなく、スタイル、関数、引数の任意の組み合わせに対して `broadcasted(::DestStyle, f, args...)` を特殊化できます。

たとえば、次の定義は範囲の否定をサポートします。

```julia
broadcasted(::DefaultArrayStyle{1}, ::typeof(-), r::OrdinalRange) = range(-first(r), step=-step(r), length=length(r))
```

### [Extending in-place broadcasting](@id extending-in-place-broadcast)

適切な `copyto!(dest, bc::Broadcasted)` メソッドを定義すれば、インプレースのブロードキャストをサポートできます。`dest` または `bc` の特定のサブタイプに対して特殊化する場合があるため、パッケージ間の曖昧さを避けるために、次の規約に従うことを推奨します。

特定のスタイル `DestStyle` に対して特殊化する場合は、次のメソッドを定義します。

```julia
copyto!(dest, bc::Broadcasted{DestStyle})
```

この形式では、必要に応じて `dest` の型に対しても特殊化できます。

一方、`DestStyle` に対する特殊化は行わず、出力先の型 `DestType` に対して特殊化したい場合は、次のシグネチャでメソッドを定義してください。

```julia
copyto!(dest::DestType, bc::Broadcasted{Nothing})
```

これは、ラッパーを `Broadcasted{Nothing}` に変換する `copyto!` のフォールバック実装を利用します。そのため、`DestType` に対する特殊化は、`DestStyle` に対する特殊化より優先順位が低くなります。

同様に、`copy(::Broadcasted)` メソッドを使って、配列外へのブロードキャストを全面的に上書きすることもできます。

#### Working with `Broadcasted` objects

このような `copy` または `copyto!` メソッドを実装するには、各要素を計算するために `Broadcasted` ラッパーを扱う必要があります。主な方法は2つあります。

  * `Broadcast.flatten` は、入れ子になっている可能性のある演算を、単一の関数とフラットな引数リストに再構成します。ブロードキャストの形状規則は自分で実装する必要がありますが、限られた状況では役立つことがあります。
  * `axes(::Broadcasted)` の `CartesianIndices` を反復し、得られた `CartesianIndex` オブジェクトでインデックスアクセスして結果を計算します。

### [Writing binary broadcasting rules](@id writing-binary-broadcasting-rules)

優先順位規則は、二項の `BroadcastStyle` 呼び出しで定義します。

```julia
Base.BroadcastStyle(::Style1, ::Style2) = Style12()
```

ここで `Style12` は、`Style1` と `Style2` の引数を含む出力に対して選択したい `BroadcastStyle` です。たとえば、

```julia
Base.BroadcastStyle(::Broadcast.Style{Tuple}, ::Broadcast.AbstractArrayStyle{0}) = Broadcast.Style{Tuple}()
```

これは、`Tuple` が0次元配列より「優先される」ことを示します（出力コンテナーはタプルになります）。この呼び出しについて、引数の順序を入れ替えた両方の形式を定義する必要はなく、定義すべきでもありません。ユーザーがどちらの順序で引数を渡しても、片方を定義すれば十分です。

`AbstractArray` 型では、`BroadcastStyle` を定義すると、フォールバックの選択である [`Broadcast.DefaultArrayStyle`](@ref) が置き換えられます。`DefaultArrayStyle` と抽象スーパータイプ `AbstractArrayStyle` は、次元数を型パラメーターとして保持します。これにより、次元数に固定の要件がある特殊な配列型をサポートできます。

`DefaultArrayStyle` は、次のメソッドが定義されているため、定義済みの他の `AbstractArrayStyle` より「優先順位が低く」なります。

```julia
BroadcastStyle(a::AbstractArrayStyle{Any}, ::DefaultArrayStyle) = a
BroadcastStyle(a::AbstractArrayStyle{N}, ::DefaultArrayStyle{N}) where N = a
BroadcastStyle(a::AbstractArrayStyle{M}, ::DefaultArrayStyle{N}) where {M,N} =
    typeof(a)(Val(max(M, N)))
```

`DefaultArrayStyle` 以外の型が2つ以上あり、それらの優先順位を定めたい場合を除き、二項の `BroadcastStyle` 規則を書く必要はありません。

配列型に次元数の固定要件がある場合は、`AbstractArrayStyle` のサブタイプにしてください。たとえば、疎配列のコードでは次のように定義されています。

```julia
struct SparseVecStyle <: Broadcast.AbstractArrayStyle{1} end
struct SparseMatStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseVector}) = SparseVecStyle()
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatStyle()
```

`AbstractArrayStyle` のサブタイプにする場合は、`Val(N)` 引数を取るスタイルのコンストラクターを作成し、次元数を組み合わせる規則も定義する必要があります。たとえば、次のようにします。

```julia
SparseVecStyle(::Val{0}) = SparseVecStyle()
SparseVecStyle(::Val{1}) = SparseVecStyle()
SparseVecStyle(::Val{2}) = SparseMatStyle()
SparseVecStyle(::Val{N}) where N = Broadcast.DefaultArrayStyle{N}()
```

これらの規則では、`SparseVecStyle` と0次元または1次元配列を組み合わせると別の `SparseVecStyle` になり、2次元配列と組み合わせると `SparseMatStyle` になり、それより高次元の場合は任意の次元数に対応する密配列の仕組みにフォールバックすることを示しています。これにより、1次元または2次元の出力になる演算では疎表現を維持し、それ以外の次元数では `Array` を生成できます。

## [Instance Properties](@id man-instance-properties)

| 実装するメソッド                                         | デフォルト定義                 | 簡単な説明                                                                                    |
|:------------------------------------------------ |:----------------------- |:---------------------------------------------------------------------------------------- |
| `propertynames(x::ObjType, private::Bool=false)` | `fieldnames(typeof(x))` | オブジェクト `x` のプロパティ（`x.property`）のタプルを返します。`private=true` の場合は、非公開として扱うプロパティ名も返します。        |
| `getproperty(x::ObjType, s::Symbol)`             | `getfield(x, s)`        | `x` のプロパティ `s` を返します。`x.s` は `getproperty(x, :s)` を呼び出します。                               |
| `setproperty!(x::ObjType, s::Symbol, v)`         | `setfield!(x, s, v)`    | `x` のプロパティ `s` に `v` を設定します。`x.s = v` は `setproperty!(x, :s, v)` を呼び出します。`v` を返す必要があります。 |

オブジェクトのフィールドに対するエンドユーザーの操作方法を変えたい場合があります。型のフィールドに直接アクセスさせる代わりに、`object.field` をオーバーロードして、ユーザーとコードの間に抽象化レイヤーを追加できます。プロパティはユーザーから見えるオブジェクトの姿であり、フィールドはオブジェクトの実際の構成要素です。

デフォルトでは、プロパティとフィールドは同じです。ただし、この動作は変更できます。たとえば、[polar coordinates](https://en.wikipedia.org/wiki/Polar_coordinate_system) で平面上の点を次のように表すとします。

```jldoctest polartype
julia> mutable struct Point
           r::Float64
           ϕ::Float64
       end

julia> p = Point(7.0, pi/4)
Point(7.0, 0.7853981633974483)
```

上の表で説明したように、ドットアクセス `p.r` は `getproperty(p, :r)` と同じであり、デフォルトでは `getfield(p, :r)` と同じです。

```jldoctest polartype
julia> propertynames(p)
(:r, :ϕ)

julia> getproperty(p, :r), getproperty(p, :ϕ)
(7.0, 0.7853981633974483)

julia> p.r, p.ϕ
(7.0, 0.7853981633974483)

julia> getfield(p, :r), getproperty(p, :ϕ)
(7.0, 0.7853981633974483)
```

しかし、`Point` が座標を `r` と `ϕ`（フィールド）として格納していることをユーザーに意識させず、代わりに `x` と `y`（プロパティ）を通じて操作させたい場合があります。新しい機能を追加するには、左端の列にあるメソッドを定義します。

```jldoctest polartype
julia> Base.propertynames(::Point, private::Bool=false) = private ? (:x, :y, :r, :ϕ) : (:x, :y)

julia> function Base.getproperty(p::Point, s::Symbol)
           if s === :x
               return getfield(p, :r) * cos(getfield(p, :ϕ))
           elseif s === :y
               return getfield(p, :r) * sin(getfield(p, :ϕ))
           else
               # This allows accessing fields with p.r and p.ϕ
               return getfield(p, s)
           end
       end

julia> function Base.setproperty!(p::Point, s::Symbol, f)
           if s === :x
               y = p.y
               setfield!(p, :r, sqrt(f^2 + y^2))
               setfield!(p, :ϕ, atan(y, f))
               return f
           elseif s === :y
               x = p.x
               setfield!(p, :r, sqrt(x^2 + f^2))
               setfield!(p, :ϕ, atan(f, x))
               return f
           else
               # This allow modifying fields with p.r and p.ϕ
               return setfield!(p, s, f)
           end
       end
```

`getproperty` と `setproperty!` の内部では、ドット構文ではなく `getfield` と `setfield` を使うことが重要です。ドット構文を使うと関数が再帰的に呼び出され、型推論の問題につながる可能性があるためです。これで、新しい機能を試せます。

```jldoctest polartype
julia> propertynames(p)
(:x, :y)

julia> p.x
4.949747468305833

julia> p.y = 4.0
4.0

julia> p.r
6.363961030678928
```

最後に、このようにインスタンスプロパティを追加することはJuliaではかなりまれであり、一般に、そうする十分な理由がある場合に限って行うべきです。

## [Rounding](@id man-rounding-interface)

| 実装するメソッド                                      | デフォルト定義                   | 簡単な説明                                                     |
|:--------------------------------------------- |:------------------------- |:--------------------------------------------------------- |
| `round(x::ObjType, r::RoundingMode)`          | なし                        | `x` を丸めて結果を返します。可能であれば、round は `x` と同じ型のオブジェクトを返す必要があります。 |
| `round(T::Type, x::ObjType, r::RoundingMode)` | `convert(T, round(x, r))` | `x` を丸め、結果を `T` として返します。                                  |

新しい型で丸めをサポートするには、通常、`round(x::ObjType, r::RoundingMode)` という単一のメソッドを定義すれば十分です。渡された丸めモードによって、値をどの方向に丸めるかが決まります。よく使われる丸めモードは `RoundNearest`、`RoundToZero`、`RoundDown`、`RoundUp` です。これらの丸めモードは、引数1つの `round` メソッドと、`trunc`、`floor`、`ceil` の定義でそれぞれ使われます。

場合によっては、2引数メソッドを呼び出してから変換するよりも、3引数の `round` メソッドを定義したほうが、精度や性能が向上することがあります。その場合は、2引数メソッドに加えて3引数メソッドを定義してもかまいません。丸めた結果を型 `T` のオブジェクトとして表現できない場合、3引数メソッドは `InexactError` をスローする必要があります。

たとえば、https://github.com/JuliaPhysics/Measurements.jl, に似た、可能な値の範囲を表す `Interval` 型があるとします。この型の丸めは、次のように定義できます。

```jldoctest
julia> struct Interval{T}
           min::T
           max::T
       end

julia> Base.round(x::Interval, r::RoundingMode) = Interval(round(x.min, r), round(x.max, r))

julia> x = Interval(1.7, 2.2)
Interval{Float64}(1.7, 2.2)

julia> round(x)
Interval{Float64}(2.0, 2.0)

julia> floor(x)
Interval{Float64}(1.0, 2.0)

julia> ceil(x)
Interval{Float64}(2.0, 3.0)

julia> trunc(x)
Interval{Float64}(1.0, 2.0)
```

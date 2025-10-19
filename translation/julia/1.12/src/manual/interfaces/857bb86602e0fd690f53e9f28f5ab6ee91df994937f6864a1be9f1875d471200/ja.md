# Interfaces

Juliaの多くの力と拡張性は、非公式なインターフェースのコレクションから来ています。特定のメソッドをカスタムタイプに対して機能するように拡張することで、そのタイプのオブジェクトはこれらの機能を受け取るだけでなく、それらの動作に基づいて一般的に構築される他のメソッドでも使用できるようになります。

## [Iteration](@id man-interface-iteration)

常に必要とされる2つのメソッドがあります：

| Required method         | Brief description                                                                        |
|:----------------------- |:---------------------------------------------------------------------------------------- |
| [`iterate(iter)`](@ref) | Returns either a tuple of the first item and initial state or [`nothing`](@ref) if empty |
| `iterate(iter, state)`  | Returns either a tuple of the next item and next state or `nothing` if no items remain   |

いくつかの状況で定義すべき追加のメソッドがあります。常に `Base.IteratorSize(IterType)` と `length(iter)` のいずれかを少なくとも1つは定義する必要があることに注意してください。なぜなら、`Base.IteratorSize(IterType)` のデフォルト定義は `Base.HasLength()` だからです。

| Method                                  | When should this method be defined?                                         | Default definition | Brief description                                                                                                                                                                                        |
|:--------------------------------------- |:--------------------------------------------------------------------------- |:------------------ |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`Base.IteratorSize(IterType)`](@ref)   | If default is not appropriate                                               | `Base.HasLength()` | One of `Base.HasLength()`, `Base.HasShape{N}()`, `Base.IsInfinite()`, or `Base.SizeUnknown()` as appropriate                                                                                             |
| [`length(iter)`](@ref)                  | If `Base.IteratorSize()` returns `Base.HasLength()` or `Base.HasShape{N}()` | (*undefined*)      | The number of items, if known                                                                                                                                                                            |
| [`size(iter, [dim])`](@ref)             | If `Base.IteratorSize()` returns `Base.HasShape{N}()`                       | (*undefined*)      | The number of items in each dimension, if known                                                                                                                                                          |
| [`Base.IteratorEltype(IterType)`](@ref) | If default is not appropriate                                               | `Base.HasEltype()` | Either `Base.EltypeUnknown()` or `Base.HasEltype()` as appropriate                                                                                                                                       |
| [`eltype(IterType)`](@ref)              | If default is not appropriate                                               | `Any`              | The type of the first entry of the tuple returned by `iterate()`                                                                                                                                         |
| [`Base.isdone(iter, [state])`](@ref)    | **Must** be defined if iterator is stateful                                 | `missing`          | Fast-path hint for iterator completion. If not defined for a stateful iterator then functions that check for done-ness, like `isempty()` and `zip()`, may mutate the iterator and cause buggy behaviour! |

逐次反復は [`iterate`](@ref) 関数によって実装されています。オブジェクトを反復処理する際に変更するのではなく、Juliaのイテレータはオブジェクトとは別に反復状態を追跡することができます。`iterate` からの戻り値は常に値と状態のタプル、または要素が残っていない場合は `nothing` です。状態オブジェクトは次の反復で `iterate` 関数に渡され、一般的にはイテラブルオブジェクトに対してプライベートな実装の詳細と見なされます。

この関数を定義する任意のオブジェクトは反復可能であり、[many functions that rely upon iteration](@ref lib-collections-iteration)で使用できます。また、構文があるため、[`for`](@ref)ループ内で直接使用することもできます。

```julia
for item in iter   # or  "for item = iter"
    # body
end
```

翻訳されます:

```julia
next = iterate(iter)
while next !== nothing
    (item, state) = next
    # body
    next = iterate(iter, state)
end
```

定義された長さの平方数の反復可能なシーケンスの簡単な例です：

```jldoctest squaretype
julia> struct Squares
           count::Int
       end

julia> Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
```

[`iterate`](@ref) の定義だけで、`Squares` 型はすでに非常に強力です。すべての要素を反復処理できます：

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

イテラブルで動作する多くの組み込みメソッドを使用できます。例えば、[`in`](@ref)や[`sum`](@ref)のように：

```jldoctest squaretype
julia> 25 in Squares(10)
true

julia> sum(Squares(100))
338350
```

いくつかの方法を拡張して、Juliaにこの反復可能なコレクションに関するより多くの情報を提供できます。`Squares` シーケンスの要素は常に `Int` であることがわかっています。[`eltype`](@ref) メソッドを拡張することで、その情報をJuliaに提供し、より複雑なメソッドでより専門的なコードを生成するのを助けることができます。また、シーケンス内の要素の数もわかっているので、[`length`](@ref) も拡張できます。

```jldoctest squaretype
julia> Base.eltype(::Type{Squares}) = Int # Note that this is defined for the type

julia> Base.length(S::Squares) = S.count
```

今、私たちがジュリアに [`collect`](@ref) すべての要素を配列に入れるように頼むと、無邪気に [`push!`](@ref) 各要素を `Vector{Any}` に入れるのではなく、適切なサイズの `Vector{Int}` を事前に割り当てることができます。

```jldoctest squaretype
julia> collect(Squares(4))
4-element Vector{Int64}:
  1
  4
  9
 16
```

一般的な実装に依存することもできますが、より簡単なアルゴリズムがあることがわかっている特定のメソッドを拡張することもできます。たとえば、平方和を計算するための公式があるので、一般的な反復バージョンをよりパフォーマンスの高いソリューションでオーバーライドすることができます。

```jldoctest squaretype
julia> Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)

julia> sum(Squares(1803))
1955361914
```

これはJulia Base全体で非常に一般的なパターンです：少数の必須メソッドが非公式なインターフェースを定義し、多くの洗練された動作を可能にします。場合によっては、型は特定のケースでより効率的なアルゴリズムを使用できることを知っているときに、その追加の動作をさらに特化させたいと考えることがあります。

コレクションを*逆順*で反復処理することを許可することは、しばしば便利です。[`Iterators.reverse(iterator)`](@ref)を反復処理することで実現できます。ただし、逆順の反復処理を実際にサポートするには、イテレータ型`T`が`Iterators.Reverse{T}`のために`iterate`を実装する必要があります。（`r::Iterators.Reverse{T}`が与えられた場合、型`T`の基になるイテレータは`r.itr`です。）私たちの`Squares`の例では、`Iterators.Reverse{Squares}`メソッドを実装します：

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

| Methods to implement | Brief description                                             |
|:-------------------- |:------------------------------------------------------------- |
| `getindex(X, i)`     | `X[i]`, indexed access, non-scalar `i` should allocate a copy |
| `setindex!(X, v, i)` | `X[i] = v`, indexed assignment                                |
| `firstindex(X)`      | The first index, used in `X[begin]`                           |
| `lastindex(X)`       | The last index, used in `X[end]`                              |

`Squares` iterableの上記の内容に対して、シーケンスの`i`番目の要素を平方することで簡単に計算できます。これをインデックス式`S[i]`として公開できます。この動作を利用するには、`Squares`は単に[`getindex`](@ref)を定義する必要があります。

```jldoctest squaretype
julia> function Base.getindex(S::Squares, i::Int)
           1 <= i <= S.count || throw(BoundsError(S, i))
           return i*i
       end

julia> Squares(100)[23]
529
```

さらに、構文 `S[begin]` と `S[end]` をサポートするために、最初と最後の有効なインデックスをそれぞれ指定するために [`firstindex`](@ref) と [`lastindex`](@ref) を定義する必要があります。

```jldoctest squaretype
julia> Base.firstindex(S::Squares) = 1

julia> Base.lastindex(S::Squares) = length(S)

julia> Squares(23)[end]
529
```

多次元の `begin`/`end` インデックス指定、例えば `a[3, begin, 7]` の場合、`firstindex(a, dim)` と `lastindex(a, dim)` を定義する必要があります（これらはそれぞれ `axes(a, dim)` に対して `first` と `last` を呼び出すことがデフォルトです）。

注意してください、上記は [`getindex`](@ref) を1つの整数インデックスでのみ定義します。`Int` 以外のものでインデックスを付けると、[`MethodError`](@ref) がスローされ、一致するメソッドがないことを示します。範囲や `Int` のベクトルでのインデックス付けをサポートするためには、別のメソッドを作成する必要があります：

```jldoctest squaretype
julia> Base.getindex(S::Squares, i::Number) = S[convert(Int, i)]

julia> Base.getindex(S::Squares, I) = [S[i] for i in I]

julia> Squares(10)[[3,4.,5]]
3-element Vector{Int64}:
  9
 16
 25
```

この [indexing operations supported by some of the builtin types](@ref man-array-indexing) のサポートが進んでいる一方で、まだ多くの動作が欠けています。この `Squares` シーケンスは、動作を追加するにつれて、ますますベクトルのように見えてきています。これらの動作をすべて自分たちで定義する代わりに、公式に [`AbstractArray`](@ref) のサブタイプとして定義することができます。

## [Abstract Arrays](@id man-interface-array)

| Methods to implement                     |                                        | Brief description                                                                                                                                                |
|:---------------------------------------- |:-------------------------------------- |:---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `size(A)`                                |                                        | Returns a tuple containing the dimensions of `A`                                                                                                                 |
| `getindex(A, i::Int)`                    |                                        | (if `IndexLinear`) Linear scalar indexing                                                                                                                        |
| `getindex(A, I::Vararg{Int, N})`         |                                        | (if `IndexCartesian`, where `N = ndims(A)`) N-dimensional scalar indexing                                                                                        |
| **Optional methods**                     | **Default definition**                 | **Brief description**                                                                                                                                            |
| `IndexStyle(::Type)`                     | `IndexCartesian()`                     | Returns either `IndexLinear()` or `IndexCartesian()`. See the description below.                                                                                 |
| `setindex!(A, v, i::Int)`                |                                        | (if `IndexLinear`) Scalar indexed assignment                                                                                                                     |
| `setindex!(A, v, I::Vararg{Int, N})`     |                                        | (if `IndexCartesian`, where `N = ndims(A)`) N-dimensional scalar indexed assignment                                                                              |
| `getindex(A, I...)`                      | defined in terms of scalar `getindex`  | [Multidimensional and nonscalar indexing](@ref man-array-indexing)                                                                                               |
| `setindex!(A, X, I...)`                  | defined in terms of scalar `setindex!` | [Multidimensional and nonscalar indexed assignment](@ref man-array-indexing)                                                                                     |
| `iterate`                                | defined in terms of scalar `getindex`  | Iteration                                                                                                                                                        |
| `length(A)`                              | `prod(size(A))`                        | Number of elements                                                                                                                                               |
| `similar(A)`                             | `similar(A, eltype(A), size(A))`       | Return a mutable array with the same shape and element type                                                                                                      |
| `similar(A, ::Type{S})`                  | `similar(A, S, size(A))`               | Return a mutable array with the same shape and the specified element type                                                                                        |
| `similar(A, dims::Dims)`                 | `similar(A, eltype(A), dims)`          | Return a mutable array with the same element type and size *dims*                                                                                                |
| `similar(A, ::Type{S}, dims::Dims)`      | `Array{S}(undef, dims)`                | Return a mutable array with the specified element type and size                                                                                                  |
| **Non-traditional indices**              | **Default definition**                 | **Brief description**                                                                                                                                            |
| `axes(A)`                                | `map(OneTo, size(A))`                  | Return a tuple of `AbstractUnitRange{<:Integer}` of valid indices. The axes should be their own axes, that is `axes.(axes(A),1) == axes(A)` should be satisfied. |
| `similar(A, ::Type{S}, inds)`            | `similar(A, S, Base.to_shape(inds))`   | Return a mutable array with the specified indices `inds` (see below)                                                                                             |
| `similar(T::Union{Type,Function}, inds)` | `T(Base.to_shape(inds))`               | Return an array similar to `T` with the specified indices `inds` (see below)                                                                                     |

もし型が `AbstractArray` のサブタイプとして定義されている場合、単一要素アクセスの上に構築された反復処理や多次元インデックス付けを含む非常に大きなセットの豊かな動作を継承します。サポートされているメソッドの詳細については、[arrays manual page](@ref man-multi-dim-arrays) と [Julia Base section](@ref lib-arrays) を参照してください。

`AbstractArray` サブタイプを定義する上での重要な部分は [`IndexStyle`](@ref) です。インデックス付けは配列の重要な部分であり、しばしばホットループ内で発生するため、インデックス付けとインデックス付き代入の両方をできるだけ効率的にすることが重要です。配列データ構造は通常、2つの方法のいずれかで定義されます：要素に対して単一のインデックスを使用して最も効率的にアクセスする（線形インデックス）か、すべての次元に対して指定されたインデックスで要素に本質的にアクセスするかです。これら2つのモダリティは、Juliaによって `IndexLinear()` と `IndexCartesian()` として識別されます。線形インデックスを複数のインデックスサブスクリプトに変換することは通常非常に高価であるため、これはすべての配列タイプに対して効率的な汎用コードを可能にするためのトレイトベースのメカニズムを提供します。

この区別は、型が定義しなければならないスカラーインデックスメソッドを決定します。 `IndexLinear()` 配列はシンプルで、`getindex(A::ArrayType, i::Int)` を定義するだけです。その後、配列が多次元のインデックスセットでインデックス付けされると、フォールバックの `getindex(A::AbstractArray, I...)` がインデックスを1つの線形インデックスに効率的に変換し、上記のメソッドを呼び出します。一方、`IndexCartesian()` 配列は、`ndims(A)` の `Int` インデックスを持つ各サポートされている次元に対してメソッドを定義する必要があります。例えば、[`SparseMatrixCSC`](@ref) は `SparseArrays` 標準ライブラリモジュールからのもので、2次元のみをサポートしているため、`getindex(A::SparseMatrixCSC, i::Int, j::Int)` を定義するだけです。同様のことが [`setindex!`](@ref) にも当てはまります。

上記の平方の列に戻ると、それを `AbstractArray{Int, 1}` のサブタイプとして定義することもできます:

```jldoctest squarevectype
julia> struct SquaresVector <: AbstractArray{Int, 1}
           count::Int
       end

julia> Base.size(S::SquaresVector) = (S.count,)

julia> Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()

julia> Base.getindex(S::SquaresVector, i::Int) = i*i
```

`AbstractArray`の2つのパラメータを指定することが非常に重要であることに注意してください。最初のパラメータは[`eltype`](@ref)を定義し、2番目のパラメータは[`ndims`](@ref)を定義します。そのスーパタイプとこれら3つのメソッドがあれば、`SquaresVector`は反復可能で、インデックス可能で、完全に機能する配列になります。

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

より複雑な例として、[`Dict`](@ref)の上に構築された独自のトイN次元スパースライク配列タイプを定義しましょう：

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

この配列は `IndexCartesian` 配列であることに注意してください。したがって、配列の次元において [`getindex`](@ref) と [`setindex!`](@ref) を手動で定義する必要があります。`SquaresVector` とは異なり、`4d61726b646f776e2e436f64652822222c2022736574696e646578212229_40726566` を定義することができるため、配列を変更することができます。

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

The result of indexing an `AbstractArray` can itself be an array (for instance when indexing by an `AbstractRange`). The `AbstractArray` fallback methods use [`similar`](@ref) to allocate an `Array` of the appropriate size and element type, which is filled in using the basic indexing method described above. However, when implementing an array wrapper you often want the result to be wrapped as well:

```jldoctest squarevectype
julia> A[1:2,:]
2×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
```

この例では、`Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where T`を定義することで、適切なラップされた配列を作成することが達成されます。（`similar`が1引数および2引数の形式をサポートしていることに注意してください。ほとんどの場合、3引数の形式を特化させるだけで十分です。）これが機能するためには、`SparseArray`が可変であること（`setindex!`をサポートしていること）が重要です。`SparseArray`のために`similar`、`getindex`、および`setindex!`を定義することは、配列を[`copy`](@ref)することも可能にします：

```jldoctest squarevectype
julia> copy(A)
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
```

上記のすべての反復可能およびインデックス可能なメソッドに加えて、これらの型は互いに相互作用し、`AbstractArrays`のためにJulia Baseで定義されたほとんどのメソッドを使用することもできます：

```jldoctest squarevectype
julia> A[SquaresVector(3)]
3-element SparseArray{Float64, 1}:
 1.0
 4.0
 9.0

julia> sum(A)
45.0
```

配列型を定義する際に、非伝統的なインデックス（1以外の数値から始まるインデックス）を許可する場合は、[`axes`](@ref)を特化する必要があります。また、[`similar`](@ref)も特化して、`dims`引数（通常は`Dims`サイズタプル）が`AbstractUnitRange`オブジェクトを受け入れられるようにする必要があります。おそらく、独自の設計による範囲型`Ind`を使用することができます。詳細については、[Arrays with custom indices](@ref man-custom-indices)を参照してください。

## [Strided Arrays](@id man-interface-strided-arrays)

| Methods to implement                     |                        | Brief description                                                                                                                                                                   |
|:---------------------------------------- |:---------------------- |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `strides(A)`                             |                        | Return the distance in memory (in number of elements) between adjacent elements in each dimension as a tuple. If `A` is an `AbstractArray{T,0}`, this should return an empty tuple. |
| `Base.unsafe_convert(::Type{Ptr{T}}, A)` |                        | Return the native address of an array.                                                                                                                                              |
| `Base.elsize(::Type{<:A})`               |                        | Return the stride between consecutive elements in the array.                                                                                                                        |
| **Optional methods**                     | **Default definition** | **Brief description**                                                                                                                                                               |
| `stride(A, i::Int)`                      | `strides(A)[i]`        | Return the distance in memory (in number of elements) between adjacent elements in dimension k.                                                                                     |

ストライド配列は、エントリが固定ストライドでメモリに格納される `AbstractArray` のサブタイプです。配列の要素型が BLAS と互換性がある場合、ストライド配列は BLAS および LAPACK ルーチンを利用して、より効率的な線形代数ルーチンを実行できます。ユーザー定義のストライド配列の典型的な例は、標準の `Array` を追加の構造でラップしたものです。

警告: 基本ストレージが実際にストライドされていない場合、これらのメソッドを実装しないでください。そうしないと、誤った結果やセグメンテーションフォルトが発生する可能性があります。

ストライドされた配列とそうでない配列のタイプを示すいくつかの例を以下に示します：

```julia
1:5   # not strided (there is no storage associated with this array.)
Vector(1:5)  # is strided with strides (1,)
A = [1 5; 2 6; 3 7; 4 8]  # is strided with strides (1,4)
V = view(A, 1:2, :)   # is strided with strides (1,4)
V = view(A, 1:2:3, 1:2)   # is strided with strides (2,4)
V = view(A, [1,2,4], :)   # is not strided, as the spacing between rows is not fixed.
```

## [Customizing broadcasting](@id man-interfaces-broadcasting)

| Methods to implement                                       | Brief description                                                  |
|:---------------------------------------------------------- |:------------------------------------------------------------------ |
| `Base.BroadcastStyle(::Type{SrcType}) = SrcStyle()`        | Broadcasting behavior of `SrcType`                                 |
| `Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})` | Allocation of output container                                     |
| **Optional methods**                                       |                                                                    |
| `Base.BroadcastStyle(::Style1, ::Style2) = Style12()`      | Precedence rules for mixing styles                                 |
| `Base.axes(x)`                                             | Declaration of the indices of `x`, as per [`axes(x)`](@ref).       |
| `Base.broadcastable(x)`                                    | Convert `x` to an object that has `axes` and supports indexing     |
| **Bypassing default machinery**                            |                                                                    |
| `Base.copy(bc::Broadcasted{DestStyle})`                    | Custom implementation of `broadcast`                               |
| `Base.copyto!(dest, bc::Broadcasted{DestStyle})`           | Custom implementation of `broadcast!`, specializing on `DestStyle` |
| `Base.copyto!(dest::DestType, bc::Broadcasted{Nothing})`   | Custom implementation of `broadcast!`, specializing on `DestType`  |
| `Base.Broadcast.broadcasted(f, args...)`                   | Override the default lazy behavior within a fused expression       |
| `Base.Broadcast.instantiate(bc::Broadcasted{DestStyle})`   | Override the computation of the lazy broadcast's axes              |

[Broadcasting](@ref) は、`broadcast` または `broadcast!` への明示的な呼び出しによって、または `A .+ b` や `f.(x, y)` のような「ドット」操作によって暗黙的にトリガーされます。[`axes`](@ref) を持ち、インデックス付けをサポートする任意のオブジェクトは、ブロードキャスティングの引数として参加できます。デフォルトでは、結果は `Array` に格納されます。この基本的なフレームワークは、3つの主要な方法で拡張可能です：

  * すべての引数がブロードキャストをサポートしていることを確認する
  * 与えられた引数のセットに対して適切な出力配列を選択する
  * 与えられた引数のセットに対して効率的な実装を選択する

すべてのタイプが `axes` とインデックスをサポートしているわけではありませんが、多くのタイプはブロードキャストを許可するために便利です。[`Base.broadcastable`](@ref) 関数は、ブロードキャストのために各引数に対して呼び出され、`axes` とインデックスをサポートする異なるものを返すことができます。デフォルトでは、これはすべての `AbstractArray` と `Number` に対する恒等関数です — それらはすでに `axes` とインデックスをサポートしています。

もし型が「0次元スカラー」（単一のオブジェクト）として機能することを意図している場合、次のメソッドを定義する必要があります：

```julia
Base.broadcastable(o::MyType) = Ref(o)
```

引数を0次元の [`Ref`](@ref) コンテナにラップして返します。例えば、そのようなラッパーメソッドは、型自体、関数、[`missing`](@ref) や [`nothing`](@ref) のような特別なシングルトン、そして日付に対して定義されています。

カスタム配列のような型は、形状を定義するために `Base.broadcastable` を特化できますが、`collect(Base.broadcastable(x)) == collect(x)` という規則に従う必要があります。注目すべき例外は `AbstractString` です。文字列は、文字のイテラブルコレクションであるにもかかわらず、ブロードキャストの目的のためにスカラーとして振る舞うように特別扱いされています（詳細は [Strings](@ref) を参照してください）。

次の2つのステップ（出力配列の選択と実装）は、与えられた引数のセットに対して単一の答えを決定することに依存しています。ブロードキャストは、その引数のさまざまなタイプをすべて取り込み、単一の出力配列と単一の実装にまとめる必要があります。ブロードキャストは、この単一の答えを「スタイル」と呼びます。すべてのブロードキャスト可能なオブジェクトは、それぞれ独自の好ましいスタイルを持っており、これらのスタイルを単一の答え—「宛先スタイル」に結合するために、昇格のようなシステムが使用されます。

### Broadcast Styles

`Base.BroadcastStyle` は、すべてのブロードキャストスタイルが派生する抽象型です。関数として使用されると、単項（単一引数）と二項の2つの可能な形式があります。単項バリアントは、特定のブロードキャスト動作および/または出力タイプを実装する意図があり、デフォルトのフォールバック [`Broadcast.DefaultArrayStyle`](@ref) に依存したくないことを示します。

これらのデフォルトを上書きするには、オブジェクトのためにカスタム `BroadcastStyle` を定義できます：

```julia
struct MyStyle <: Broadcast.BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyType}) = MyStyle()
```

場合によっては、`MyStyle`を定義する必要がない方が便利なことがあります。その場合、一般的なブロードキャストラッパーの1つを利用できます。

  * `Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.Style{MyType}()` は任意の型に対して使用できます。
  * `Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.ArrayStyle{MyType}()` は、`MyType` が `AbstractArray` の場合に推奨されます。
  * `N`次元のみをサポートする`AbstractArrays`の場合、`Broadcast.AbstractArrayStyle{N}`のサブタイプを作成します（以下を参照）。

放送操作に複数の引数が関与する場合、個々の引数スタイルが組み合わさって出力コンテナのタイプを制御する単一の `DestStyle` が決定されます。詳細については、[below](@ref writing-binary-broadcasting-rules) を参照してください。

### Selecting an appropriate output array

ブロードキャストスタイルは、ディスパッチと特化を可能にするために、すべてのブロードキャスティング操作に対して計算されます。結果配列の実際の割り当ては、`similar`によって処理され、ブロードキャストされたオブジェクトが最初の引数として使用されます。

```julia
Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})
```

フォールバックの定義は

```julia
similar(bc::Broadcasted{DefaultArrayStyle{N}}, ::Type{ElType}) where {N,ElType} =
    similar(Array{ElType}, axes(bc))
```

ただし、必要に応じて、これらの引数のいずれかまたはすべてに特化することができます。最終的な引数 `bc` は、（潜在的に融合された）ブロードキャスト操作の怠惰な表現であり、`Broadcasted` オブジェクトです。これらの目的のために、ラッパーの最も重要なフィールドは `f` と `args` であり、それぞれ関数と引数リストを説明しています。引数リストには、他のネストされた `Broadcasted` ラッパーが含まれることがあり、しばしばそうなります。

完全な例として、`ArrayAndChar`という型を作成したとしましょう。この型は配列と単一の文字を格納します。

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

ブロードキャスティングが `char` "メタデータ" を保持することを望むかもしれません。まず、私たちは定義します。

```jldoctest ArrayAndChar; output = false
Base.BroadcastStyle(::Type{<:ArrayAndChar}) = Broadcast.ArrayStyle{ArrayAndChar}()
# output

```

これは、対応する `similar` メソッドも定義する必要があることを意味します：

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

これらの定義から、次のような挙動が得られます：

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

一般に、ブロードキャスト操作は、適用される関数とその引数を保持する遅延`Broadcasted`コンテナによって表されます。これらの引数自体が、よりネストされた`Broadcasted`コンテナである場合もあり、大きな式ツリーを形成して評価されます。ネストされた`Broadcasted`コンテナのツリーは、暗黙のドット構文によって直接構築されます。例えば、`5 .+ 2.*x`は一時的に`Broadcasted(+, 5, Broadcasted(*, 2, x))`として表されます。これはユーザーには見えませんが、`copy`への呼び出しを通じて即座に実現されます。しかし、このコンテナがカスタムタイプの著者にとってブロードキャストの拡張性の基礎を提供します。組み込みのブロードキャスト機構は、引数に基づいて結果の型とサイズを決定し、それを割り当て、最後にデフォルトの`copyto!(::AbstractArray, ::Broadcasted)`メソッドを使用して`Broadcasted`オブジェクトの実現をそれにコピーします。組み込みのフォールバック`broadcast`および`broadcast!`メソッドも同様に、操作の一時的な`Broadcasted`表現を構築し、同じコードパスに従うことができます。これにより、カスタム配列実装は、ブロードキャストをカスタマイズおよび最適化するために独自の`copyto!`特殊化を提供できます。これは計算されたブロードキャストスタイルによって再び決定されます。これは操作の非常に重要な部分であり、`Broadcasted`型の最初の型パラメータとして保存され、ディスパッチと特殊化を可能にします。

一部の型において、ネストされたブロードキャスティングのレベルをまたいで操作を「融合」するための仕組みが利用できないか、または段階的により効率的に行うことができる場合があります。そのような場合、`x .* (x .+ 1)`を`broadcast(*, x, broadcast(+, x, 1))`のように書かれたかのように評価する必要があるか、またはそうしたい場合があります。ここで、内側の操作は外側の操作に取り組む前に評価されます。この種のイager操作は、少しの間接的なサポートによって直接サポートされています。Juliaは、融合された式`x .* (x .+ 1)`を`Broadcast.broadcasted(*, x, Broadcast.broadcasted(+, x, 1))`に低下させます。デフォルトでは、`broadcasted`は単に`Broadcasted`コンストラクタを呼び出して融合された式ツリーの遅延表現を作成しますが、特定の関数と引数の組み合わせに対してオーバーライドすることを選択できます。

例えば、組み込みの `AbstractRange` オブジェクトは、この仕組みを利用して、開始点、ステップ、および長さ（または停止）に基づいて純粋に早期に評価できるブロードキャストされた式の部分を最適化します。その他の仕組みと同様に、`broadcasted` もその引数の組み合わせたブロードキャストスタイルを計算して公開します。したがって、`broadcasted(f, args...)` に特化する代わりに、任意のスタイル、関数、および引数の組み合わせに対して `broadcasted(::DestStyle, f, args...)` に特化することができます。

例えば、以下の定義は範囲の否定をサポートしています：

```julia
broadcasted(::DefaultArrayStyle{1}, ::typeof(-), r::OrdinalRange) = range(-first(r), step=-step(r), length=length(r))
```

### [Extending in-place broadcasting](@id extending-in-place-broadcast)

インプレースブロードキャスティングは、適切な `copyto!(dest, bc::Broadcasted)` メソッドを定義することでサポートできます。`dest` または `bc` の特定のサブタイプに特化したい場合があるため、パッケージ間の曖昧さを避けるために、以下の規約を推奨します。

特定のスタイル `DestStyle` に特化したい場合は、メソッドを定義します。

```julia
copyto!(dest, bc::Broadcasted{DestStyle})
```

オプションとして、このフォームを使用すると、`dest`のタイプを専門化することもできます。

`DestType`の種類に特化したいが、`DestStyle`には特化したくない場合は、次のシグネチャを持つメソッドを定義する必要があります。

```julia
copyto!(dest::DestType, bc::Broadcasted{Nothing})
```

これは、ラッパーを `Broadcasted{Nothing}` に変換する `copyto!` のフォールバック実装を活用しています。その結果、`DestType` に特化することは、`DestStyle` に特化するメソッドよりも優先度が低くなります。

同様に、`copy(::Broadcasted)` メソッドを使用して、場違いなブロードキャスティングを完全にオーバーライドすることができます。

#### Working with `Broadcasted` objects

そのような `copy` または `copyto!` メソッドを実装するためには、もちろん、各要素を計算するために `Broadcasted` ラッパーを使用する必要があります。これを行う主な方法は2つあります：

  * `Broadcast.flatten` は、潜在的にネストされた操作を単一の関数と引数のフラットなリストに再計算します。ブロードキャストの形状ルールを自分で実装する必要がありますが、限られた状況では役立つかもしれません。
  * `axes(::Broadcasted)`の`CartesianIndices`を反復処理し、得られた`CartesianIndex`オブジェクトを使用して結果を計算します。

### [Writing binary broadcasting rules](@id writing-binary-broadcasting-rules)

優先順位ルールは、バイナリ `BroadcastStyle` 呼び出しによって定義されます：

```julia
Base.BroadcastStyle(::Style1, ::Style2) = Style12()
```

`Style12`は、`Style1`および`Style2`の引数を含む出力に対して選択したい`BroadcastStyle`です。例えば、

```julia
Base.BroadcastStyle(::Broadcast.Style{Tuple}, ::Broadcast.AbstractArrayStyle{0}) = Broadcast.Style{Tuple}()
```

`Tuple`がゼロ次元配列に対して「勝つ」ことを示しています（出力コンテナはタプルになります）。この呼び出しの引数の順序を両方定義する必要はなく（そしてすべきではなく）、ユーザーが引数をどの順序で提供しても、1つを定義するだけで十分です。

`AbstractArray` 型に対して、`BroadcastStyle` を定義することは、フォールバックの選択肢である [`Broadcast.DefaultArrayStyle`](@ref) を上書きします。`DefaultArrayStyle` と抽象スーパタイプである `AbstractArrayStyle` は、固定次元要件を持つ特殊な配列型をサポートするために、次元数を型パラメータとして格納します。

`DefaultArrayStyle` は、以下のメソッドのために定義された他の `AbstractArrayStyle` に対して「負ける」ことになります:

```julia
BroadcastStyle(a::AbstractArrayStyle{Any}, ::DefaultArrayStyle) = a
BroadcastStyle(a::AbstractArrayStyle{N}, ::DefaultArrayStyle{N}) where N = a
BroadcastStyle(a::AbstractArrayStyle{M}, ::DefaultArrayStyle{N}) where {M,N} =
    typeof(a)(Val(max(M, N)))
```

バイナリ `BroadcastStyle` ルールを書く必要はありませんが、2つ以上の非 `DefaultArrayStyle` タイプの優先順位を確立したい場合は別です。

もしあなたの配列タイプが固定次元性の要件を持っている場合、`AbstractArrayStyle`をサブタイプ化するべきです。例えば、スパース配列のコードには以下の定義があります：

```julia
struct SparseVecStyle <: Broadcast.AbstractArrayStyle{1} end
struct SparseMatStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseVector}) = SparseVecStyle()
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatStyle()
```

`AbstractArrayStyle`をサブタイプ化する際は、次元の組み合わせに関するルールも定義する必要があります。そのためには、`Val(N)`引数を受け取るスタイルのコンストラクタを作成します。例えば：

```julia
SparseVecStyle(::Val{0}) = SparseVecStyle()
SparseVecStyle(::Val{1}) = SparseVecStyle()
SparseVecStyle(::Val{2}) = SparseMatStyle()
SparseVecStyle(::Val{N}) where N = Broadcast.DefaultArrayStyle{N}()
```

これらのルールは、`SparseVecStyle`と0次元または1次元の配列の組み合わせが別の`SparseVecStyle`を生成し、2次元の配列との組み合わせが`SparseMatStyle`を生成し、より高次元のものは密な任意次元フレームワークに戻ることを示しています。これらのルールにより、ブロードキャスティングは、1次元または2次元の出力を生成する操作に対してスパース表現を維持しますが、他の次元に対しては`Array`を生成します。

## [Instance Properties](@id man-instance-properties)

| Methods to implement                             | Default definition      | Brief description                                                                                                                              |
|:------------------------------------------------ |:----------------------- |:---------------------------------------------------------------------------------------------------------------------------------------------- |
| `propertynames(x::ObjType, private::Bool=false)` | `fieldnames(typeof(x))` | Return a tuple of the properties (`x.property`) of an object `x`. If `private=true`, also return property names intended to be kept as private |
| `getproperty(x::ObjType, s::Symbol)`             | `getfield(x, s)`        | Return property `s` of `x`. `x.s` calls `getproperty(x, :s)`.                                                                                  |
| `setproperty!(x::ObjType, s::Symbol, v)`         | `setfield!(x, s, v)`    | Set property `s` of `x` to `v`. `x.s = v` calls `setproperty!(x, :s, v)`. Should return `v`.                                                   |

時には、エンドユーザーがオブジェクトのフィールドとどのように対話するかを変更することが望ましい場合があります。フィールドへの直接アクセスを許可する代わりに、ユーザーとコードの間に追加の抽象化レイヤーを提供することで、`object.field`をオーバーロードすることができます。プロパティはユーザーがオブジェクトから「見る」ものであり、フィールドはオブジェクトが「実際に何であるか」です。

デフォルトでは、プロパティとフィールドは同じです。しかし、この動作は変更できます。たとえば、[polar coordinates](https://en.wikipedia.org/wiki/Polar_coordinate_system)における平面上の点のこの表現を考えてみてください。

```jldoctest polartype
julia> mutable struct Point
           r::Float64
           ϕ::Float64
       end

julia> p = Point(7.0, pi/4)
Point(7.0, 0.7853981633974483)
```

上記の表に記載されているように、ドットアクセス `p.r` は `getproperty(p, :r)` と同じであり、デフォルトでは `getfield(p, :r)` と同じです：

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

しかし、私たちはユーザーが `Point` が座標を `r` と `ϕ`（フィールド）として保存していることに気づかないようにし、代わりに `x` と `y`（プロパティ）で対話できるようにしたいかもしれません。最初の列のメソッドは、新しい機能を追加するために定義できます：

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

`getfield` と `setfield` は、ドット構文の代わりに `getproperty` と `setproperty!` の中で使用することが重要です。ドット構文を使用すると、関数が再帰的になり、型推論の問題を引き起こす可能性があります。新しい機能を試してみましょう：

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

最後に、このようにインスタンスプロパティを追加することは、Juliaでは非常に稀であり、一般的にはそれを行う良い理由がある場合にのみ行うべきであることに注意する価値があります。

## [Rounding](@id man-rounding-interface)

| Methods to implement                          | Default definition        | Brief description                                                                                   |
|:--------------------------------------------- |:------------------------- |:--------------------------------------------------------------------------------------------------- |
| `round(x::ObjType, r::RoundingMode)`          | none                      | Round `x` and return the result. If possible, round should return an object of the same type as `x` |
| `round(T::Type, x::ObjType, r::RoundingMode)` | `convert(T, round(x, r))` | Round `x`, returning the result as a `T`                                                            |

新しいタイプでの丸めをサポートするには、通常、単一のメソッド `round(x::ObjType, r::RoundingMode)` を定義するだけで十分です。渡された丸めモードは、値がどの方向に丸められるべきかを決定します。最も一般的に使用される丸めモードは `RoundNearest`、`RoundToZero`、`RoundDown`、および `RoundUp` であり、これらの丸めモードは、1つの引数を持つ `round` メソッド、`trunc`、`floor`、および `ceil` の定義で使用されます。

場合によっては、2引数のメソッドの後に変換を行うよりも、より正確またはパフォーマンスの良い3引数の`round`メソッドを定義することが可能です。この場合、2引数のメソッドに加えて3引数のメソッドを定義することが許容されます。丸めた結果を型`T`のオブジェクトとして表現することが不可能な場合、3引数のメソッドは`InexactError`をスローするべきです。

例えば、`Interval`型があり、これはhttps://github.com/JuliaPhysics/Measurements.jlに似た可能性のある値の範囲を表す場合、その型に対して次のように丸めを定義することができます。

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

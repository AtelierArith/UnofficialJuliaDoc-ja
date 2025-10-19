# [Arrays](@id lib-arrays)

## Constructors and Types

```@docs
Core.AbstractArray
Base.AbstractVector
Base.AbstractMatrix
Base.AbstractVecOrMat
Core.Array
Core.Array(::UndefInitializer, ::Any)
Core.Array(::Nothing, ::Any)
Core.Array(::Missing, ::Any)
Core.UndefInitializer
Core.undef
Base.Vector
Base.Vector(::UndefInitializer, ::Any)
Base.Vector(::Nothing, ::Any)
Base.Vector(::Missing, ::Any)
Base.Matrix
Base.Matrix(::UndefInitializer, ::Any, ::Any)
Base.Matrix(::Nothing, ::Any, ::Any)
Base.Matrix(::Missing, ::Any, ::Any)
Base.VecOrMat
Core.DenseArray
Base.DenseVector
Base.DenseMatrix
Base.DenseVecOrMat
Base.StridedArray
Base.StridedVector
Base.StridedMatrix
Base.StridedVecOrMat
Base.GenericMemory
Base.Memory
Base.memoryref
Base.Slices
Base.RowSlices
Base.ColumnSlices
Base.getindex(::Type, ::Any...)
Base.zeros
Base.ones
Base.BitArray
Base.BitArray(::UndefInitializer, ::Integer...)
Base.BitArray(::Any)
Base.trues
Base.falses
Base.fill
Base.fill!
Base.empty
Base.similar
```

## Basic functions

```@docs
Base.ndims
Base.size
Base.axes(::Any)
Base.axes(::AbstractArray, ::Any)
Base.length(::AbstractArray)
Base.keys(::AbstractArray)
Base.eachindex
Base.IndexStyle
Base.IndexLinear
Base.IndexCartesian
Base.conj!
Base.stride
Base.strides
```

## Broadcast and vectorization

次も参照してください [dot syntax for vectorizing functions](@ref man-vectorized); 例えば、`f.(args...)` は暗黙的に `broadcast(f, args...)` を呼び出します。配列に対して `sin` のような関数の「ベクトル化」メソッドに依存するのではなく、`sin.(a)` を使用して `broadcast` を介してベクトル化するべきです。

```@docs
Base.broadcast
Base.Broadcast.broadcast!
Base.@__dot__
Base.Broadcast.BroadcastFunction
```

カスタムタイプに特化したブロードキャストについては、参照してください。

```@docs
Base.BroadcastStyle
Base.Broadcast.AbstractArrayStyle
Base.Broadcast.ArrayStyle
Base.Broadcast.DefaultArrayStyle
Base.Broadcast.broadcastable
Base.Broadcast.combine_axes
Base.Broadcast.combine_styles
Base.Broadcast.result_style
```

## Indexing and assignment

```@docs
Base.getindex(::AbstractArray, ::Any...)
Base.setindex!(::AbstractArray, ::Any, ::Any...)
Base.nextind
Base.prevind
Base.copyto!(::AbstractArray, ::CartesianIndices, ::AbstractArray, ::CartesianIndices)
Base.copy!
Base.isassigned
Base.Colon
Base.CartesianIndex
Base.CartesianIndices
Base.Dims
Base.LinearIndices
Base.to_indices
Base.checkbounds
Base.checkindex
Base.elsize
```

ほとんどのコードはインデックスに依存しない方法で記述できます（例えば、[`eachindex`](@ref)を参照）。しかし、オフセット軸を明示的にチェックすることが有用な場合もあります：

```@docs
Base.require_one_based_indexing
Base.has_offset_axes
```

## Views (SubArrays and other view types)

「ビュー」は、配列のように機能するデータ構造（`AbstractArray`のサブタイプ）ですが、基になるデータは実際には別の配列の一部です。

例えば、`x` が配列であり、`v = @view x[1:10]` の場合、`v` は10要素の配列のように振る舞いますが、そのデータは実際には `x` の最初の10要素にアクセスしています。ビューに書き込むと、例えば `v[3] = 2` のように、基になる配列 `x` に直接書き込まれます（この場合、`x[3]` を変更します）。

スライス操作 `x[1:10]` は、デフォルトでコピーを作成します。 `@view x[1:10]` は、それをビューに変更します。 `@views` マクロは、コードの全ブロックに使用することができ（例： `@views function foo() .... end` または `@views begin ... end`）、そのブロック内のすべてのスライス操作をビューを使用するように変更します。データのコピーを作成する方が速い場合もあれば、ビューを使用する方が速い場合もあります。これは [performance tips](@ref man-performance-views) に記載されています。

```@docs
Base.view
Base.@view
Base.@views
Base.parent
Base.parentindices
Base.selectdim
Base.reinterpret
Base.reshape
Base.insertdims
Base.dropdims
Base.vec
Base.SubArray
```

## Concatenation and permutation

```@docs
Base.cat
Base.vcat
Base.hcat
Base.hvcat
Base.hvncat
Base.stack
Base.vect
Base.circshift
Base.circshift!
Base.circcopy!
Base.findall(::Any)
Base.findall(::Function, ::Any)
Base.findfirst(::Any)
Base.findfirst(::Function, ::Any)
Base.findlast(::Any)
Base.findlast(::Function, ::Any)
Base.findnext(::Any, ::Integer)
Base.findnext(::Function, ::Any, ::Integer)
Base.findprev(::Any, ::Integer)
Base.findprev(::Function, ::Any, ::Integer)
Base.permutedims
Base.permutedims!
Base.PermutedDimsArray
Base.promote_shape
```

## Array functions

```@docs
Base.accumulate
Base.accumulate!
Base.cumprod
Base.cumprod!
Base.cumsum
Base.cumsum!
Base.diff
Base.repeat
Base.rot180
Base.rotl90
Base.rotr90
Base.mapslices
Base.eachrow
Base.eachcol
Base.eachslice
```

## Combinatorics

```@docs
Base.invperm
Base.isperm
Base.permute!(::Any, ::AbstractVector)
Base.invpermute!
Base.reverse(::AbstractVector; kwargs...)
Base.reverseind
Base.reverse!
```

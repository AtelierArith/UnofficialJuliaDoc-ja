```julia
getindex(A, inds...)
```

配列 `A` から、インデックス `inds` で指定した要素を返します。

各インデックスには、サポートされているインデックスの [supported index type](@ref man-supported-index-types)、たとえば [`Integer`](@ref)、[`CartesianIndex`](@ref)、[range](@ref Base.AbstractRange)、[array](@ref man-multi-dim-arrays) のいずれかを指定できます。特定の次元のすべての要素を選択するには [:](@ref Base.Colon) を使用できます。また、ブール配列（例: `Array{Bool}` や [`BitArray`](@ref)）を使うと、対応するインデックスが `true` である要素を抽出できます。

`inds` で複数の要素を選択すると、この関数は新しい配列を割り当てて返します。コピーせずに複数の要素をインデックス指定するには、代わりに [`view`](@ref) を使用してください。

詳しくは、[array indexing](@ref man-array-indexing) のマニュアルの節を参照してください。

# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> getindex(A, 1)
1

julia> getindex(A, [2, 1])
2-element Vector{Int64}:
 3
 1

julia> getindex(A, 2:4)
3-element Vector{Int64}:
 3
 2
 4

julia> getindex(A, 2, 1)
3

julia> getindex(A, CartesianIndex(2, 1))
3

julia> getindex(A, :, 2)
2-element Vector{Int64}:
 2
 4

julia> getindex(A, 2, :)
2-element Vector{Int64}:
 3
 4

julia> getindex(A, A .> 2)
2-element Vector{Int64}:
 3
 4
```

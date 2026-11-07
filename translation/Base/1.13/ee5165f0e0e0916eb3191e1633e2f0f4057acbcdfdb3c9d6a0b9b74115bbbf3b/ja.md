```julia
getindex(A, inds...)
```

インデックス `inds` で選択した配列 `A` の部分配列を返します。

各インデックスには、サポートされているインデックスの [supported index type](@ref man-supported-index-types)（たとえば、[`Integer`](@ref)、[`CartesianIndex`](@ref)、[range](@ref Base.AbstractRange)、[array](@ref man-multi-dim-arrays)）を指定できます。特定の次元に沿ったすべての要素を選択するには [:](@ref Base.Colon) を使用できます。また、ブール配列（たとえば `Array{Bool}` や [`BitArray`](@ref)）を使うと、対応するインデックスが `true` である要素を抽出できます。

`inds` が複数の要素を選択する場合、この関数は新たに確保した配列を返します。コピーせずに複数の要素をインデックス指定するには、代わりに [`view`](@ref) を使用してください。

詳しくは、マニュアルの [array indexing](@ref man-array-indexing) の節を参照してください。

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

```
getindex(A, inds...)
```

Return a subset of array `A` as selected by the indices `inds`.

Each index may be any [supported index type](@ref man-supported-index-types), such as an [`Integer`](@ref), [`CartesianIndex`](@ref), [range](@ref Base.AbstractRange), or [array](@ref man-multi-dim-arrays) of supported indices. A [:](@ref Base.Colon) may be used to select all elements along a specific dimension, and a boolean array (e.g. an `Array{Bool}` or a [`BitArray`](@ref)) may be used to filter for elements where the corresponding index is `true`.

When `inds` selects multiple elements, this function returns a newly allocated array. To index multiple elements without making a copy, use [`view`](@ref) instead.

See the manual section on [array indexing](@ref man-array-indexing) for details.

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

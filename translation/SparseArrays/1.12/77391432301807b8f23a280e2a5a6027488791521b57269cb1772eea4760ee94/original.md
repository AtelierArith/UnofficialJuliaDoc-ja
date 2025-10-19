```julia
nonzeros(A)
```

Return a vector of the structural nonzero values in sparse array `A`. This includes zeros that are explicitly stored in the sparse array. The returned vector points directly to the internal nonzero storage of `A`, and any modifications to the returned vector will mutate `A` as well. See [`rowvals`](@ref) and [`nzrange`](@ref).

# Examples

```jldoctest
julia> A = sparse(2I, 3, 3)
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 2  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  2

julia> nonzeros(A)
3-element Vector{Int64}:
 2
 2
 2
```

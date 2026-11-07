```julia
spdiagm(v::AbstractVector)
spdiagm(m::Integer, n::Integer, v::AbstractVector)
```

Construct a sparse matrix with elements of the vector as diagonal elements. By default (no given `m` and `n`), the matrix is square and its size is given by `length(v)`, but a non-square size `m`×`n` can be specified by passing `m` and `n` as the first arguments.

!!! compat "Julia 1.6"
    These functions require at least Julia 1.6.


# Examples

```jldoctest
julia> spdiagm([1,2,3])
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 1  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  3

julia> spdiagm(sparse([1,0,3]))
3×3 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 1  ⋅  ⋅
 ⋅  ⋅  ⋅
 ⋅  ⋅  3
```

```julia
spdiagm(kv::Pair{<:Integer,<:AbstractVector}...)
spdiagm(m::Integer, n::Integer, kv::Pair{<:Integer,<:AbstractVector}...)
```

Construct a sparse diagonal matrix from `Pair`s of vectors and diagonals. Each vector `kv.second` will be placed on the `kv.first` diagonal.  By default, the matrix is square and its size is inferred from `kv`, but a non-square size `m`×`n` (padded with zeros as needed) can be specified by passing `m,n` as the first arguments.

# Examples

```jldoctest
julia> spdiagm(-1 => [1,2,3,4], 1 => [4,3,2,1])
5×5 SparseMatrixCSC{Int64, Int64} with 8 stored entries:
 ⋅  4  ⋅  ⋅  ⋅
 1  ⋅  3  ⋅  ⋅
 ⋅  2  ⋅  2  ⋅
 ⋅  ⋅  3  ⋅  1
 ⋅  ⋅  ⋅  4  ⋅
```

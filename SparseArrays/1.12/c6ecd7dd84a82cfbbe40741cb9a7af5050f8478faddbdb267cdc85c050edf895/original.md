```julia
sparsevec(A)
```

Convert a vector `A` into a sparse vector of length `m`. Numerical zeros in `A` are turned into structural zeros.

# Examples

```jldoctest
julia> sparsevec([1.0, 2.0, 0.0, 0.0, 3.0, 0.0])
6-element SparseVector{Float64, Int64} with 3 stored entries:
  [1]  =  1.0
  [2]  =  2.0
  [5]  =  3.0
```

```julia
findnz(x::SparseVector)
```

Return a tuple `(I, V)`  where `I` is the indices of the stored ("structurally non-zero") values in sparse vector-like `x` and `V` is a vector of the values.

# Examples

```jldoctest
julia> x = sparsevec([1 2 0; 0 0 3; 0 4 0])
9-element SparseVector{Int64, Int64} with 4 stored entries:
  [1]  =  1
  [4]  =  2
  [6]  =  4
  [8]  =  3

julia> findnz(x)
([1, 4, 6, 8], [1, 2, 4, 3])
```

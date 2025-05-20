```
dropstored!(x::SparseVector, i::Integer)
```

Drop entry `x[i]` from `x` if `x[i]` is stored and otherwise do nothing.

# Examples

```jldoctest
julia> x = sparsevec([1, 3], [1.0, 2.0])
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  1.0
  [3]  =  2.0

julia> SparseArrays.dropstored!(x, 3)
3-element SparseVector{Float64, Int64} with 1 stored entry:
  [1]  =  1.0

julia> SparseArrays.dropstored!(x, 2)
3-element SparseVector{Float64, Int64} with 1 stored entry:
  [1]  =  1.0
```

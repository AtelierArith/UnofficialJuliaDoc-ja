```
dropstored!(A::AbstractSparseMatrixCSC, i::Integer, j::Integer)
```

Drop entry `A[i,j]` from `A` if `A[i,j]` is stored, and otherwise do nothing.

```jldoctest
julia> A = sparse([1 2; 0 0])
2×2 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 1  2
 ⋅  ⋅

julia> SparseArrays.dropstored!(A, 1, 2); A
2×2 SparseMatrixCSC{Int64, Int64} with 1 stored entry:
 1  ⋅
 ⋅  ⋅
```

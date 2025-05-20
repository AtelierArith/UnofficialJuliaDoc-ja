```
findnz(A::SparseMatrixCSC)
```

Return a tuple `(I, J, V)` where `I` and `J` are the row and column indices of the stored ("structurally non-zero") values in sparse matrix `A`, and `V` is a vector of the values.

# Examples

```jldoctest
julia> A = sparse([1 2 0; 0 0 3; 0 4 0])
3×3 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  2  ⋅
 ⋅  ⋅  3
 ⋅  4  ⋅

julia> findnz(A)
([1, 1, 3, 2], [1, 2, 2, 3], [1, 2, 4, 3])
```

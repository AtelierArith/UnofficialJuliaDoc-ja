```
dropstored!(A::AbstractSparseMatrixCSC, I::AbstractVector{<:Integer}, J::AbstractVector{<:Integer})
```

For each `(i,j)` where `i in I` and `j in J`, drop entry `A[i,j]` from `A` if `A[i,j]` is stored and otherwise do nothing. Derivative forms:

```
dropstored!(A::AbstractSparseMatrixCSC, i::Integer, J::AbstractVector{<:Integer})
dropstored!(A::AbstractSparseMatrixCSC, I::AbstractVector{<:Integer}, j::Integer)
```

# Examples

```jldoctest
julia> A = sparse(Diagonal([1, 2, 3, 4]))
4×4 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  ⋅  ⋅  ⋅
 ⋅  2  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  4

julia> SparseArrays.dropstored!(A, [1, 2], [1, 1])
4×4 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 ⋅  ⋅  ⋅  ⋅
 ⋅  2  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  4
```

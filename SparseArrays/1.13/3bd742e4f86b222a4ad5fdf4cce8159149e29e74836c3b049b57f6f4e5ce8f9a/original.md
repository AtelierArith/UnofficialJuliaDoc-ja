```julia
rowcheck_index(A::AbstractSparseMatrixCSC, row::Integer, col::Integer)
```

Check if A[row, col] is a stored value, and return the index of the row in `rowvals(A)`. Returns `(row_exists, row_ind)`, where `row_exists::Bool` signifies whether the corresponding index is populated, and `row_ind` is the index. If `row_exists` is `false`, the `row_ind` is the index where the value should be inserted into `rowvals(A)` such that the subarray `@view rowvals(A)[nzrange(A, col)]` remains sorted.

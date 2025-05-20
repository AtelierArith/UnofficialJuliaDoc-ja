```
spzeros([type], I::AbstractVector, J::AbstractVector, [m, n])
```

Create a sparse matrix `S` of dimensions `m x n` with structural zeros at `S[I[k], J[k]]`.

This method can be used to construct the sparsity pattern of the matrix, and is more efficient than using e.g. `sparse(I, J, zeros(length(I)))`.

For additional documentation and an expert driver, see `SparseArrays.spzeros!`.

!!! compat "Julia 1.10"
    This methods requires Julia version 1.10 or later.


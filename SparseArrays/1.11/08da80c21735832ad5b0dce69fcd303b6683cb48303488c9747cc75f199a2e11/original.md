```
unwrap(A::AbstractMatrix)
```

In case A is a wrapper type (`SubArray, Symmetric, Adjoint, SubArray, Triangular, Tridiagonal`, etc.) convert to `Matrix` or `SparseMatrixCSC`, depending on final storage type of A. For other types return A itself.

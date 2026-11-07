```julia
gesv!(A, B) -> (B, A, ipiv)
```

Solves the linear equation `A * X = B` where `A` is a square matrix using the `LU` factorization of `A`. `A` is overwritten with its `LU` factorization and `B` is overwritten with the solution `X`. `ipiv` contains the pivoting information for the `LU` factorization of `A`.

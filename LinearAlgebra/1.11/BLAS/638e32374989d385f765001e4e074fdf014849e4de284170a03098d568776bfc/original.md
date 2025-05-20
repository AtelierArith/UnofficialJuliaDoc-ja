```
gemmt!(uplo, tA, tB, alpha, A, B, beta, C)
```

Update the lower or upper triangular part specified by [`uplo`](@ref stdlib-blas-uplo) of `C` as `alpha*A*B + beta*C` or the other variants according to [`tA`](@ref stdlib-blas-trans) and `tB`. Return the updated `C`.

!!! compat "Julia 1.11"
    `gemmt!` requires at least Julia 1.11.


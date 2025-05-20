```
gemmt(uplo, tA, tB, alpha, A, B)
```

Return the lower or upper triangular part specified by [`uplo`](@ref stdlib-blas-uplo) of `A*B` or the other three variants according to [`tA`](@ref stdlib-blas-trans) and `tB`.

!!! compat "Julia 1.11"
    `gemmt` requires at least Julia 1.11.


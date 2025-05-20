```
syrk(uplo, trans, alpha, A)
```

Return either the upper triangle or the lower triangle of `A`, according to [`uplo`](@ref stdlib-blas-uplo), of `alpha*A*transpose(A)` or `alpha*transpose(A)*A`, according to [`trans`](@ref stdlib-blas-trans).

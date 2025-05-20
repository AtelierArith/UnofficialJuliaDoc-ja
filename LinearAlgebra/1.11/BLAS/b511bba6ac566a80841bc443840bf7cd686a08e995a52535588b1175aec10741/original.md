```
her2k!(uplo, trans, alpha, A, B, beta, C)
```

Rank-2k update of the Hermitian matrix `C` as `alpha*A*B' + alpha*B*A' + beta*C` or `alpha*A'*B + alpha*B'*A + beta*C` according to [`trans`](@ref stdlib-blas-trans). The scalar `beta` has to be real. Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `C` is used. Return `C`.

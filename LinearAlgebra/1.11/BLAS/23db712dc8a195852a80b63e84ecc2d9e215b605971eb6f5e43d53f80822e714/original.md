```
syr2k!(uplo, trans, alpha, A, B, beta, C)
```

Rank-2k update of the symmetric matrix `C` as `alpha*A*transpose(B) + alpha*B*transpose(A) + beta*C` or `alpha*transpose(A)*B + alpha*transpose(B)*A + beta*C` according to [`trans`](@ref stdlib-blas-trans). Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `C` is used. Returns `C`.

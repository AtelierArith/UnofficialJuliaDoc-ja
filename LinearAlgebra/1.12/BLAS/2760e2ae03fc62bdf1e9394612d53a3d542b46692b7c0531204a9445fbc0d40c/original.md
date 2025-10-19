```julia
syrk!(uplo, trans, alpha, A, beta, C)
```

Rank-k update of the symmetric matrix `C` as `alpha*A*transpose(A) + beta*C` or `alpha*transpose(A)*A + beta*C` according to [`trans`](@ref stdlib-blas-trans). Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `C` is used. Return `C`.

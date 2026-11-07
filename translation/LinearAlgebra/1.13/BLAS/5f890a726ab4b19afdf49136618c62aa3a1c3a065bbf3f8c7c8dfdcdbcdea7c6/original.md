```julia
herk!(uplo, trans, alpha, A, beta, C)
```

Methods for complex arrays only. Rank-k update of the Hermitian matrix `C` as `alpha*A*A' + beta*C` or `alpha*A'*A + beta*C` according to [`trans`](@ref stdlib-blas-trans). Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `C` is updated. Returns `C`.

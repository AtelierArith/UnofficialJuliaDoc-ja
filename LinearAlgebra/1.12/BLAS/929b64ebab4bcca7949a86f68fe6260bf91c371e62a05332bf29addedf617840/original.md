```julia
her2k(uplo, trans, alpha, A, B)
```

Return the [`uplo`](@ref stdlib-blas-uplo) triangle of `alpha*A*B' + alpha*B*A'` or `alpha*A'*B + alpha*B'*A`, according to [`trans`](@ref stdlib-blas-trans).

```julia
hemm(side, ul, alpha, A, B)
```

Return `alpha*A*B` or `alpha*B*A` according to [`side`](@ref stdlib-blas-side). `A` is assumed to be Hermitian. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used.

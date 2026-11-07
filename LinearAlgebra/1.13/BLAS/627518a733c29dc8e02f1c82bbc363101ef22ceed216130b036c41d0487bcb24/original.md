```julia
hemv(ul, A, x)
```

Return `A*x`. `A` is assumed to be Hermitian. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used.

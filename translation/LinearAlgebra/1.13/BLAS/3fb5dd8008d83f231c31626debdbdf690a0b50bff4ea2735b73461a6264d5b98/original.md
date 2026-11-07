```julia
symv(ul, alpha, A, x)
```

Return `alpha*A*x`. `A` is assumed to be symmetric. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used. `alpha` is a scalar.

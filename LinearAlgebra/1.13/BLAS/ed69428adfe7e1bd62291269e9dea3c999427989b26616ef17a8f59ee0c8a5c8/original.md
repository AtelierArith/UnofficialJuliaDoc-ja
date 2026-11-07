```julia
symv!(ul, alpha, A, x, beta, y)
```

Update the vector `y` as `alpha*A*x + beta*y`. `A` is assumed to be symmetric. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used. `alpha` and `beta` are scalars. Return the updated `y`.

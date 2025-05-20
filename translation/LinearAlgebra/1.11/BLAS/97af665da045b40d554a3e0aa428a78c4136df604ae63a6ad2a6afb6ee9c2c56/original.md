```
symm!(side, ul, alpha, A, B, beta, C)
```

Update `C` as `alpha*A*B + beta*C` or `alpha*B*A + beta*C` according to [`side`](@ref stdlib-blas-side). `A` is assumed to be symmetric. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used. Return the updated `C`.

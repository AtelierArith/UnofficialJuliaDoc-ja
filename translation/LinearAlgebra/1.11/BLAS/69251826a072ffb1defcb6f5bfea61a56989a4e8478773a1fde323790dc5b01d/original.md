```
gemv!(tA, alpha, A, x, beta, y)
```

Update the vector `y` as `alpha*A*x + beta*y` or `alpha*A'x + beta*y` according to [`tA`](@ref stdlib-blas-trans). `alpha` and `beta` are scalars. Return the updated `y`.

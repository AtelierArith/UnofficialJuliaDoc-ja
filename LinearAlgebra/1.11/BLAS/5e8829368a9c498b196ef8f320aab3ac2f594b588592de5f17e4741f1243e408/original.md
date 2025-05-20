```
symm(side, ul, A, B)
```

Return `A*B` or `B*A` according to [`side`](@ref stdlib-blas-side). `A` is assumed to be symmetric. Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used.

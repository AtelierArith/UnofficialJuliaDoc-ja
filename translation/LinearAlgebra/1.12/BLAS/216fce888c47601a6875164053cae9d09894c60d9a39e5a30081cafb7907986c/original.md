```julia
sbmv(uplo, k, A, x)
```

Return `A*x` where `A` is a symmetric band matrix of order `size(A,2)` with `k` super-diagonals stored in the argument `A`. Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `A` is used.

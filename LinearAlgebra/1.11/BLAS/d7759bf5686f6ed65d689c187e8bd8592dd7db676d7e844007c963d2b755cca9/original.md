```
sbmv!(uplo, k, alpha, A, x, beta, y)
```

Update vector `y` as `alpha*A*x + beta*y` where `A` is a symmetric band matrix of order `size(A,2)` with `k` super-diagonals stored in the argument `A`. The storage layout for `A` is described the reference BLAS module, level-2 BLAS at [https://www.netlib.org/lapack/explore-html/](https://www.netlib.org/lapack/explore-html/). Only the [`uplo`](@ref stdlib-blas-uplo) triangle of `A` is used.

Return the updated `y`.

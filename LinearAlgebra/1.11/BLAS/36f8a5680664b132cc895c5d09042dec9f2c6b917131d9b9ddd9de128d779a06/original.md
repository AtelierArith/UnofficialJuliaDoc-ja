```
gbmv(trans, m, kl, ku, alpha, A, x)
```

Return `alpha*A*x` or `alpha*A'*x` according to [`trans`](@ref stdlib-blas-trans). The matrix `A` is a general band matrix of dimension `m` by `size(A,2)` with `kl` sub-diagonals and `ku` super-diagonals, and `alpha` is a scalar.

```
gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)
```

Update vector `y` as `alpha*A*x + beta*y` or `alpha*A'*x + beta*y` according to [`trans`](@ref stdlib-blas-trans). The matrix `A` is a general band matrix of dimension `m` by `size(A,2)` with `kl` sub-diagonals and `ku` super-diagonals. `alpha` and `beta` are scalars. Return the updated `y`.

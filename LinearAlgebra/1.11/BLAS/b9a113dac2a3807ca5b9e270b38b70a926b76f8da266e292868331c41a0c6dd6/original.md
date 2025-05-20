```
syr!(uplo, alpha, x, A)
```

Rank-1 update of the symmetric matrix `A` with vector `x` as `alpha*x*transpose(x) + A`. [`uplo`](@ref stdlib-blas-uplo) controls which triangle of `A` is updated. Returns `A`.

```julia
her!(uplo, alpha, x, A)
```

Methods for complex arrays only. Rank-1 update of the Hermitian matrix `A` with vector `x` as `alpha*x*x' + A`. [`uplo`](@ref stdlib-blas-uplo) controls which triangle of `A` is updated. Returns `A`.

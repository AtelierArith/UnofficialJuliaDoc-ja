```julia
syr2k(uplo, trans, alpha, A, B)
```

Returns the [`uplo`](@ref stdlib-blas-uplo) triangle of `alpha*A*transpose(B) + alpha*B*transpose(A)` or `alpha*transpose(A)*B + alpha*transpose(B)*A`, according to [`trans`](@ref stdlib-blas-trans).

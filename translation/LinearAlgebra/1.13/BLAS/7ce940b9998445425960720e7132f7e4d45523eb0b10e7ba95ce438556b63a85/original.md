```julia
syr2k(uplo, trans, A, B)
```

Return the [`uplo`](@ref stdlib-blas-uplo) triangle of `A*transpose(B) + B*transpose(A)` or `transpose(A)*B + transpose(B)*A`, according to [`trans`](@ref stdlib-blas-trans).

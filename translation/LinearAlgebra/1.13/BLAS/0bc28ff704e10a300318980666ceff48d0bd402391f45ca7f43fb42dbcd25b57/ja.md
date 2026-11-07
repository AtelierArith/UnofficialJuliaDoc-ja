```julia
syr2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角形を返します。[`trans`](@ref stdlib-blas-trans) に応じて、`alpha*A*transpose(B) + alpha*B*transpose(A)` または `alpha*transpose(A)*B + alpha*transpose(B)*A` のいずれかになります。

```julia
syr2k(uplo, trans, alpha, A, B)
```

[`trans`](@ref stdlib-blas-trans)に応じて、`alpha*A*transpose(B) + alpha*B*transpose(A)`または`alpha*transpose(A)*B + alpha*transpose(B)*A`の[`uplo`](@ref stdlib-blas-uplo)三角行列を返します。

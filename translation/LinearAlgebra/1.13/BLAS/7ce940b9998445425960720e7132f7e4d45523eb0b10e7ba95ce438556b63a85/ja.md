```julia
syr2k(uplo, trans, A, B)
```

[`trans`](@ref stdlib-blas-trans)に応じて、`A*transpose(B) + B*transpose(A)`または`transpose(A)*B + transpose(B)*A`の[`uplo`](@ref stdlib-blas-uplo)三角形を返します。

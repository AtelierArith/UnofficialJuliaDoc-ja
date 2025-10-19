```julia
syrk(uplo, trans, alpha, A)
```

`A`の上三角または下三角を返します。これは[`uplo`](@ref stdlib-blas-uplo)に従い、`alpha*A*transpose(A)`または`alpha*transpose(A)*A`を返します。これは[`trans`](@ref stdlib-blas-trans)に従います。

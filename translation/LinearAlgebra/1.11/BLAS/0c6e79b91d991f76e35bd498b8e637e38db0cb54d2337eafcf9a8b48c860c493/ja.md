```
syrk(uplo, trans, alpha, A)
```

`A`の上三角または下三角を、[`uplo`](@ref stdlib-blas-uplo)に従って返します。`alpha*A*transpose(A)`または`alpha*transpose(A)*A`を、[`trans`](@ref stdlib-blas-trans)に従って返します。

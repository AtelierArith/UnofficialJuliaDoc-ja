```julia
herk(uplo, trans, alpha, A)
```

複素数配列に対するメソッドのみです。[`trans`](@ref stdlib-blas-trans)に応じて、`alpha*A*A'`または`alpha*A'*A`の[`uplo`](@ref stdlib-blas-uplo)三角部分を返します。

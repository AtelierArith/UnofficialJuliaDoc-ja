```julia
her2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角形を、[`trans`](@ref stdlib-blas-trans) に応じて `alpha*A*B' + alpha'*B*A'` または `alpha*A'*B + alpha'*B'*A` で返します。

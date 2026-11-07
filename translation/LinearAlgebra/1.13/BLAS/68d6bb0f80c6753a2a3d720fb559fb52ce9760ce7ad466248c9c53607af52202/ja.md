```julia
her2k(uplo, trans, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角形を、[`trans`](@ref stdlib-blas-trans) に応じて `A*B' + B*A'` または `A'*B + B'*A` で返します。

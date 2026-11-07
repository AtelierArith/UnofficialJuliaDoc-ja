```julia
her2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) `alpha*A*B' + alpha'*B*A'` または `alpha*A'*B + alpha'*B'*A` の三角形を、[`trans`](@ref stdlib-blas-trans) に従って返します。

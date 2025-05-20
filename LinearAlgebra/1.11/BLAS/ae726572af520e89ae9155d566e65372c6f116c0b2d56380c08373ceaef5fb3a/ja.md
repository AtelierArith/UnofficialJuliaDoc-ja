```
syr2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角行列 `alpha*A*transpose(B) + alpha*B*transpose(A)` または `alpha*transpose(A)*B + alpha*transpose(B)*A` を、[`trans`](@ref stdlib-blas-trans) に従って返します。

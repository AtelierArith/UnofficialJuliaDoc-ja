```
her2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角行列を返します。これは `alpha*A*B' + alpha*B*A'` または `alpha*A'*B + alpha*B'*A` であり、[`trans`](@ref stdlib-blas-trans) に応じて異なります。

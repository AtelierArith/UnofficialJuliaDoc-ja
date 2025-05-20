```
herk(uplo, trans, alpha, A)
```

複素配列専用のメソッドです。[`trans`](@ref stdlib-blas-trans) に従って、`alpha*A*A'` または `alpha*A'*A` の [`uplo`](@ref stdlib-blas-uplo) 三角行列を返します。

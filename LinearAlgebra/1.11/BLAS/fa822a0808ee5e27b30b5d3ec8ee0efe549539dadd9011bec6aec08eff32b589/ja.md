```
herk!(uplo, trans, alpha, A, beta, C)
```

複素配列専用のメソッド。エルミート行列 `C` のランク-k 更新を `alpha*A*A' + beta*C` または `alpha*A'*A + beta*C` の形で行います。これは [`trans`](@ref stdlib-blas-trans) に従います。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみが更新されます。`C` を返します。

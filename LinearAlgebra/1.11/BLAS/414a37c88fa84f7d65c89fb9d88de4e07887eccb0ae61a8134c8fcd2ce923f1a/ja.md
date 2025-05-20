```
syrk!(uplo, trans, alpha, A, beta, C)
```

対称行列 `C` のランク-k 更新を `alpha*A*transpose(A) + beta*C` または `alpha*transpose(A)*A + beta*C` の形で行います。これは [`trans`](@ref stdlib-blas-trans) に従います。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角形のみが使用されます。`C` を返します。

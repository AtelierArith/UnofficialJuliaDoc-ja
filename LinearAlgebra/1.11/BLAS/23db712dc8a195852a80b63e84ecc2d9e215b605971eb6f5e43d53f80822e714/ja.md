```
syr2k!(uplo, trans, alpha, A, B, beta, C)
```

対称行列 `C` のランク-2k 更新を `alpha*A*transpose(B) + alpha*B*transpose(A) + beta*C` または `alpha*transpose(A)*B + alpha*transpose(B)*A + beta*C` として行います。これは [`trans`](@ref stdlib-blas-trans) に従います。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角形のみが使用されます。`C` を返します。

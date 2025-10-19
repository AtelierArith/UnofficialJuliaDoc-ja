```julia
syrk!(uplo, trans, alpha, A, beta, C)
```

対称行列 `C` のランク-k 更新を `alpha*A*transpose(A) + beta*C` または `alpha*transpose(A)*A + beta*C` に従って行います。これは [`trans`](@ref stdlib-blas-trans) によります。`C` のみ [`uplo`](@ref stdlib-blas-uplo) 三角形が使用されます。`C` を返します。

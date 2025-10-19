```julia
syr2k!(uplo, trans, alpha, A, B, beta, C)
```

対称行列 `C` のランク-2k 更新を `alpha*A*transpose(B) + alpha*B*transpose(A) + beta*C` または `alpha*transpose(A)*B + alpha*transpose(B)*A + beta*C` に従って行います [`trans`](@ref stdlib-blas-trans)。`C` のみ [`uplo`](@ref stdlib-blas-uplo) 三角形が使用されます。`C` を返します。

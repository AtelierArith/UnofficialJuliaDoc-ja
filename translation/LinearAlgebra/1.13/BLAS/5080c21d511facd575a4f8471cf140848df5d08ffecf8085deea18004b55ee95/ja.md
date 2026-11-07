```julia
syr2k!(uplo, trans, alpha, A, B, beta, C)
```

対称行列 `C` を、[`trans`](@ref stdlib-blas-trans) に従って `alpha*A*transpose(B) + alpha*B*transpose(A) + beta*C` または `alpha*transpose(A)*B + alpha*transpose(B)*A + beta*C` としてランク 2k 更新します。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみを使用します。`C` を返します。

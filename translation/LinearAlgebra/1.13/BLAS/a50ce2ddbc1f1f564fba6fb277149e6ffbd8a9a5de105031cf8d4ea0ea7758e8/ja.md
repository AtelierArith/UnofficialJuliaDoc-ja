```julia
syrk!(uplo, trans, alpha, A, beta, C)
```

`C` を、[`trans`](@ref stdlib-blas-trans) に従って `alpha*A*transpose(A) + beta*C` または `alpha*transpose(A)*A + beta*C` としてランク k 更新します。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみを使用します。`C` を返します。

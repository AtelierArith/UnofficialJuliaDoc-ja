```julia
her2k!(uplo, trans, alpha, A, B, beta, C)
```

エルミート行列 `C` を、[`trans`](@ref stdlib-blas-trans) に従って `alpha*A*B' + alpha'*B*A' + beta*C` または `alpha*A'*B + alpha'*B'*A + beta*C` としてランク 2k 更新します。スカラー `beta` は実数でなければなりません。`C` のうち、[`uplo`](@ref stdlib-blas-uplo) 三角部分のみを使用します。`C` を返します。

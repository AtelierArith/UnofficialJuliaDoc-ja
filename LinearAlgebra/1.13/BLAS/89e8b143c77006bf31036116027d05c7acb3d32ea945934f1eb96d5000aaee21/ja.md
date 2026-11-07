```julia
her2k!(uplo, trans, alpha, A, B, beta, C)
```

`C` を [`trans`](@ref stdlib-blas-trans) に従って `alpha*A*B' + alpha'*B*A' + beta*C` または `alpha*A'*B + alpha'*B'*A + beta*C` として更新する、エルミート行列のランク 2k 更新。スカラー `beta` は実数でなければなりません。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみを使用します。`C` を返します。

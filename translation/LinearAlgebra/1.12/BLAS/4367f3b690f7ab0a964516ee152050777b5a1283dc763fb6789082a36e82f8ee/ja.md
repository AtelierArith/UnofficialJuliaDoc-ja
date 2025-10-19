```julia
her2k!(uplo, trans, alpha, A, B, beta, C)
```

エルミート行列 `C` のランク-2k 更新を `alpha*A*B' + alpha*B*A' + beta*C` または `alpha*A'*B + alpha*B'*A + beta*C` として行います。これは [`trans`](@ref stdlib-blas-trans) に従います。スカラー `beta` は実数でなければなりません。`C` の [`uplo`](@ref stdlib-blas-uplo) 三角形のみが使用されます。`C` を返します。

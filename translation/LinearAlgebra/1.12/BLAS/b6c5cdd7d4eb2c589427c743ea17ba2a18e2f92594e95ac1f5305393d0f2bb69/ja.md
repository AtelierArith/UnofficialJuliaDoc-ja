```julia
hemv!(ul, alpha, A, x, beta, y)
```

ベクトル `y` を `alpha*A*x + beta*y` として更新します。`A` はエルミート行列であると仮定します。`A` の [`ul`](@ref stdlib-blas-uplo) 三角部分のみが使用されます。`alpha` と `beta` はスカラーです。更新された `y` を返します。

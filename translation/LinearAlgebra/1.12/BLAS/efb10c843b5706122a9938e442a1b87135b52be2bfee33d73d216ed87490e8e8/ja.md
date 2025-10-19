```julia
symv!(ul, alpha, A, x, beta, y)
```

ベクトル `y` を `alpha*A*x + beta*y` として更新します。`A` は対称であると仮定されます。`A` の [`ul`](@ref stdlib-blas-uplo) 三角形のみが使用されます。`alpha` と `beta` はスカラーです。更新された `y` を返します。

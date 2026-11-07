```julia
symv!(ul, alpha, A, x, beta, y)
```

ベクトル `y` を `alpha*A*x + beta*y` として更新します。`A` は対称であると仮定します。[`ul`](@ref stdlib-blas-uplo) 三角形の `A` のみを使用します。`alpha` と `beta` はスカラーです。更新後の `y` を返します。

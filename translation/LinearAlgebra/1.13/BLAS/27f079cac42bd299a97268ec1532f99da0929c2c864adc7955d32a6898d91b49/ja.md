```julia
gemv!(tA, alpha, A, x, beta, y)
```

`y` ベクトルを、[`tA`](@ref stdlib-blas-trans) に従って `alpha*A*x + beta*y` または `alpha*A'x + beta*y` に更新します。`alpha` と `beta` はスカラーです。更新後の `y` を返します。

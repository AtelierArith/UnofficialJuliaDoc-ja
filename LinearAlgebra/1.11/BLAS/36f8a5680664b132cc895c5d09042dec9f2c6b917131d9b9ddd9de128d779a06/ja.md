```
gbmv(trans, m, kl, ku, alpha, A, x)
```

`alpha*A*x` または `alpha*A'*x` を [`trans`](@ref stdlib-blas-trans) に従って返します。行列 `A` は、`kl` の下三角成分と `ku` の上三角成分を持つ、次元 `m` と `size(A,2)` の一般的なバンド行列であり、`alpha` はスカラーです。

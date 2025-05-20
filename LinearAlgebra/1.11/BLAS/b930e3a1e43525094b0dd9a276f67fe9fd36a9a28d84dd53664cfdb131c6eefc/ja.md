```
gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)
```

ベクトル `y` を `alpha*A*x + beta*y` または `alpha*A'*x + beta*y` に更新します。これは [`trans`](@ref stdlib-blas-trans) に従います。行列 `A` は、`kl` の下対角線と `ku` の上対角線を持つ、次元 `m` と `size(A,2)` の一般的なバンド行列です。`alpha` と `beta` はスカラーです。更新された `y` を返します。

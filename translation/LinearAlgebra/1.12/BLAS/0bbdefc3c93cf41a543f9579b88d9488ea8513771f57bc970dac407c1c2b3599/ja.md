```julia
gbmv(trans, m, kl, ku, alpha, A, x)
```

[`trans`](@ref stdlib-blas-trans) に従って `alpha*A*x` または `alpha*A'*x` を返します。行列 `A` は、`kl` の下三角対角線と `ku` の上三角対角線を持つ、次元 `m` と `size(A,2)` の一般的なバンド行列であり、`alpha` はスカラーです。

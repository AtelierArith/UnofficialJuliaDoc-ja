```julia
gbmv(trans, m, kl, ku, alpha, A, x)
```

[`trans`](@ref stdlib-blas-trans)に応じて、`alpha*A*x`または`alpha*A'*x`を返します。行列`A`は、`m`行`size(A,2)`列で、`kl`本の下対角線と`ku`本の上対角線を持つ一般帯行列であり、`alpha`はスカラーです。

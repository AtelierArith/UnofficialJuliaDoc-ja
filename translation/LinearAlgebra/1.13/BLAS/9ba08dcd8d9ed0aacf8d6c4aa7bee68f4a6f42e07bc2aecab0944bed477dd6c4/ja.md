```julia
gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)
```

[`trans`](@ref stdlib-blas-trans)に従って、ベクトル`y`を`alpha*A*x + beta*y`または`alpha*A'*x + beta*y`として更新します。行列`A`は、`kl`本の下対角線と`ku`本の上対角線を持つ、`m`行`size(A,2)`列の一般帯行列です。`alpha`と`beta`はスカラーです。更新後の`y`を返します。

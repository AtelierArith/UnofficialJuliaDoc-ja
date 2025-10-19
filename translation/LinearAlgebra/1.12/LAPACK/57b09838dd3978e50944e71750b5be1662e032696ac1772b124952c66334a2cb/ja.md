```julia
gttrs!(trans, dl, d, du, du2, ipiv, B)
```

方程式 `A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、または `adjoint(A) * X = B` (`trans = C`) を `gttrf!` によって計算された `LU` 因子分解を使用して解きます。`B` は解 `X` で上書きされます。

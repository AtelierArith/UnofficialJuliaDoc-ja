```julia
gttrs!(trans, dl, d, du, du2, ipiv, B)
```

`gttrf!`で計算された`LU`分解を使用して、方程式`A * X = B`（`trans = N`）、`transpose(A) * X = B`（`trans = T`）、または`adjoint(A) * X = B`（`trans = C`）を解きます。`B`は、解`X`で上書きされます。

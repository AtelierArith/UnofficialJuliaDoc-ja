```julia
gttrs!(trans, dl, d, du, du2, ipiv, B)
```

`gttrf!`で計算された`LU`分解を使って、方程式`A * X = B`（`trans = N`）、`transpose(A) * X = B`（`trans = T`）、または`adjoint(A) * X = B`（`trans = C`）を解きます。解`X`で`B`を上書きします。

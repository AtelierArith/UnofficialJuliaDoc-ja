```julia
ormqr!(side, trans, A, tau, C)
```

`geqrf!`を使って計算した`A`の`QR`分解から`Q`を用いて、`side = L`に対する`Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を計算します。または、`side = R`に対する同等の右側乗算を計算します。`C`は上書きされます。

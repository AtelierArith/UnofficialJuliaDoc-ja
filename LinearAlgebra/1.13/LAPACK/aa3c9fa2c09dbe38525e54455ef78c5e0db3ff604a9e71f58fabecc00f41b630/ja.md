```julia
gemqrt!(side, trans, V, T, C)
```

`A`の`geqrt!`を用いて計算した`QR`分解から、`side = L`に対する`Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を計算します。または、`side = R`に対して、`Q`を用いた同等の右側乗算を行います。`C`は上書きされます。

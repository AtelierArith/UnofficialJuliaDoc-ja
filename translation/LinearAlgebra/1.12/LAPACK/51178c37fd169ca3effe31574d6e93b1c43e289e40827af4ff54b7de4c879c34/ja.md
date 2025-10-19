```julia
ormqr!(side, trans, A, tau, C)
```

`Q * C` を計算します（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）は `side = L` の場合、または `side = R` の場合は同等の右側の乗算を行います。`A` の `QR` 分解から得られた `Q` を使用し、`geqrf!` を用いて計算されます。`C` は上書きされます。

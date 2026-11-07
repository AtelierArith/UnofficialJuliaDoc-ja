```julia
gemqrt!(side, trans, V, T, C)
```

`side = L` に対して `Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を計算します。または、`geqrt!` を使って計算した `A` の `QR` 分解から `Q` を使い、`side = R` に対する同等の右側乗算を計算します。`C` は上書きされます。

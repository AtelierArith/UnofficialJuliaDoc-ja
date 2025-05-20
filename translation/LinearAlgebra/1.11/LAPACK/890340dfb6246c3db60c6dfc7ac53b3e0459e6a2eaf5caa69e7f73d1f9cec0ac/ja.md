```
gemqrt!(side, trans, V, T, C)
```

`Q * C` を計算します（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を `side = L` の場合、または `geqrt!` を使用して計算された `A` の `QR` 分解からの `Q` を使用して `side = R` の場合の同等の右側の乗算を行います。`C` は上書きされます。

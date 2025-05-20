```
ormql!(side, trans, A, tau, C)
```

`Q * C` を計算します（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）で `side = L` または `side = R` の場合は `A` の `geqlf!` を使用して計算された `QL` 因子分解からの `Q` を使用します。`C` は上書きされます。

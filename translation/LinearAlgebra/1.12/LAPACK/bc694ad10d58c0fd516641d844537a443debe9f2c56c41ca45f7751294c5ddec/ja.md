```julia
ormlq!(side, trans, A, tau, C)
```

`Q * C` を計算します（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）で `side = L` の場合、または `gelqf!` を使用して計算された `A` の `LQ` 分解からの `Q` を使用して `side = R` の同等の右側の乗算を行います。`C` は上書きされます。

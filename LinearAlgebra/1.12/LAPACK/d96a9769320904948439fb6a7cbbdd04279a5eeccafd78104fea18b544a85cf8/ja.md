```julia
ormrz!(side, trans, A, tau, C)
```

行列 `C` を `tzrzf!` によって供給された変換からの `Q` で掛け算します。`side` または `trans` に応じて、掛け算は左側（`side = L, Q*C`）または右側（`side = R, C*Q`）で行われ、`Q` は未修正（`trans = N`）、転置（`trans = T`）、または共役転置（`trans = C`）のいずれかになります。掛け算の結果でインプレースで修正された行列 `C` を返します。

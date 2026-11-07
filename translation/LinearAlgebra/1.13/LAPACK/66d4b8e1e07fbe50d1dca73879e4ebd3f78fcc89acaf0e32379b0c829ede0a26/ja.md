```julia
ormrz!(side, trans, A, tau, C)
```

`tzrzf!`で指定された変換に基づき、行列 `C` に `Q` を乗算します。`side` または `trans` に応じて、左側からの乗算（`side = L, Q*C`）または右側からの乗算（`side = R, C*Q`）となります。また、`Q` は変更なし（`trans = N`）、転置（`trans = T`）、または共役転置（`trans = C`）にできます。乗算結果でインプレースに変更された行列 `C` を返します。

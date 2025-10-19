```julia
trevc!(side, howmny, select, T, VL = similar(T), VR = similar(T))
```

上三角行列 `T` の固有系を求めます。`side = R` の場合、右固有ベクトルが計算されます。`side = L` の場合、左固有ベクトルが計算されます。`side = B` の場合、両方のセットが計算されます。`howmny = A` の場合、すべての固有ベクトルが見つかります。`howmny = B` の場合、すべての固有ベクトルが見つかり、`VL` と `VR` を使用して逆変換されます。`howmny = S` の場合、`select` に対応する値の固有ベクトルのみが計算されます。

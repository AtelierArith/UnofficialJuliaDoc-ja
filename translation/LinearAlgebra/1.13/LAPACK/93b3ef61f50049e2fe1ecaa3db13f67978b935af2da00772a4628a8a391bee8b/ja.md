```julia
trevc!(side, howmny, select, T, VL = similar(T), VR = similar(T))
```

上三角行列 `T` の固有系を求めます。`side = R` の場合は右固有ベクトルを計算します。`side = L` の場合は左固有ベクトルを計算します。`side = B` の場合は、両方の固有ベクトルを計算します。`howmny = A` の場合は、すべての固有ベクトルを求めます。`howmny = B` の場合は、すべての固有ベクトルを求め、`VL` および `VR` を使って逆変換します。`howmny = S` の場合は、`select` の値に対応する固有ベクトルのみを計算します。

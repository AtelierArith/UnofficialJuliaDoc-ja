```julia
ggev3!(jobvl, jobvr, A, B) -> (alpha, beta, vl, vr)
```

ブロック化アルゴリズムを使用して、`A` と `B` の一般化固有値分解を求めます。`jobvl = N` の場合、左固有ベクトルは計算されません。`jobvr = N` の場合、右固有ベクトルは計算されません。`jobvl = V` または `jobvr = V` の場合、対応する固有ベクトルが計算されます。この関数には LAPACK 3.6.0 が必要です。

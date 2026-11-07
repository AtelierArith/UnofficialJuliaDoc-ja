```julia
stebz!(range, order, vl, vu, il, iu, abstol, dv, ev) -> (dv, iblock, isplit)
```

対称三重対角行列の固有値を計算します。対角成分は `dv`、非対角成分は `ev` です。`range = A` の場合は、すべての固有値を求めます。`range = V` の場合は、半開区間 `(vl, vu]` に含まれる固有値を求めます。`range = I` の場合は、インデックスが `il` から `iu` までの固有値を求めます。`order = B` の場合、固有値はブロック内で順序付けられます。`order = E` の場合は、すべてのブロックを通して順序付けられます。収束判定の許容誤差として `abstol` を設定できます。

```julia
stebz!(range, order, vl, vu, il, iu, abstol, dv, ev) -> (dv, iblock, isplit)
```

対角成分が `dv`、非対角成分が `ev` である対称三重対角行列の固有値を計算します。`range = A` の場合、すべての固有値を求めます。`range = V` の場合、半開区間 `(vl, vu]` に含まれる固有値を求めます。`range = I` の場合、インデックスが `il` と `iu` の間にある固有値を求めます。`order = B` の場合、固有値はブロック内で順序付けられます。`order = E` の場合、すべてのブロックを通して順序付けられます。収束判定の許容誤差として `abstol` を設定できます。

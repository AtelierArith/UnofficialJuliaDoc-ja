```
stebz!(range, order, vl, vu, il, iu, abstol, dv, ev) -> (dv, iblock, isplit)
```

対称トリディアゴナル行列の固有値を計算します。`dv` は対角成分、`ev` は非対角成分です。`range = A` の場合、すべての固有値が見つかります。`range = V` の場合、半開区間 `(vl, vu]` 内の固有値が見つかります。`range = I` の場合、インデックスが `il` と `iu` の間にある固有値が見つかります。`order = B` の場合、固有値はブロック内で順序付けられます。`order = E` の場合、すべてのブロック間で順序付けられます。`abstol` は収束のための許容誤差として設定できます。

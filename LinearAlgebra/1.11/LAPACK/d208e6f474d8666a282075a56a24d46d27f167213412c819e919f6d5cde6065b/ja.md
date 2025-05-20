```
trsyl!(transa, transb, A, B, C, isgn=1) -> (C, scale)
```

シルベスター行列方程式 `A * X +/- X * B = scale*C` を解きます。ここで `A` と `B` はどちらも準上三角行列です。`transa = N` の場合、`A` は変更されません。`transa = T` の場合、`A` は転置されます。`transa = C` の場合、`A` は共役転置されます。同様に `transb` と `B` にも適用されます。`isgn = 1` の場合、方程式 `A * X + X * B = scale * C` が解かれます。`isgn = -1` の場合、方程式 `A * X - X * B = scale * C` が解かれます。

`X`（`C` を上書き）と `scale` を返します。

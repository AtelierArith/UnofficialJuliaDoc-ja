```julia
trsyl!(transa, transb, A, B, C, isgn=1) -> (C, scale)
```

`A * X +/- X * B = scale*C` というシルベスター行列方程式を解きます。`A` と `B` は、どちらも準上三角行列です。`transa = N` の場合、`A` は変更されません。`transa = T` の場合、`A` は転置されます。`transa = C` の場合、`A` は共役転置されます。`transb` と `B` についても同様です。`isgn = 1` の場合、方程式 `A * X + X * B = scale * C` を解きます。`isgn = -1` の場合、方程式 `A * X - X * B = scale * C` を解きます。

`X` と `scale` を返します（`C` は上書きされます）。

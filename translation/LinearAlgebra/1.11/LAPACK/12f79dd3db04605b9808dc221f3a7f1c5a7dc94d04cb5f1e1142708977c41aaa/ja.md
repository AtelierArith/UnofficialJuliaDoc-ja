```
hetrf!(uplo, A, ipiv) -> (A, ipiv, info)
```

エルミート行列 `A` のバンチ-カウフマン因子分解を計算します。`uplo = U` の場合、`A` の上半分が格納されます。`uplo = L` の場合、下半分が格納されます。

因子分解によって上書きされた `A`、ピボットベクトル `ipiv`、および非負整数のエラーコード `info` を返します。`info` が正の場合、行列は特異であり、因子分解の対角部分は位置 `info` で正確にゼロになります。

```julia
hetrf!(uplo, A) -> (A, ipiv, info)
```

Hermitian 行列 `A` の Bunch-Kaufman 分解を計算します。`uplo = U` の場合、`A` の上半分が格納されます。`uplo = L` の場合、下半分が格納されます。

分解によって上書きされた `A`、ピボットベクトル `ipiv`、およびエラーコード `info` を返します。エラーコードは非負の整数です。`info` が正の場合、行列は特異であり、分解の対角部分は位置 `info` で厳密にゼロになります。

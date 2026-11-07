```julia
getrf!(A, ipiv) -> (A, ipiv, info)
```

`A`、`A = LU` のピボット付き `LU` 分解を計算します。`ipiv` にはピボット情報が格納され、`info` は、成功を示すコード（`info = 0`）、`U` にある特異値（`info = i`。この場合、`U[i,i]` は特異です）、またはエラーコード（`info < 0`）を示します。

```
syev!(jobz, uplo, A)
```

対称行列 `A` の固有値（`jobz = N`）または固有値と固有ベクトル（`jobz = V`）を求めます。`uplo = U` の場合、`A` の上三角が使用されます。`uplo = L` の場合、`A` の下三角が使用されます。

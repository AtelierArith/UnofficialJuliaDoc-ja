```julia
syevd!(jobz, uplo, A)
```

対称行列 `A` の固有値（`jobz = N`）、または固有値と固有ベクトル（`jobz = V`）を求めます。`uplo = U` の場合は `A` の上三角部分を使用し、`uplo = L` の場合は `A` の下三角部分を使用します。

```
sygvd!(itype, jobz, uplo, A, B) -> (w, A, B)
```

対称行列 `A` と対称正定値行列 `B` の一般化固有値（`jobz = N`）または固有値と固有ベクトル（`jobz = V`）を求めます。`uplo = U` の場合、`A` と `B` の上三角が使用されます。`uplo = L` の場合、`A` と `B` の下三角が使用されます。`itype = 1` の場合、解くべき問題は `A * x = lambda * B * x` です。`itype = 2` の場合、解くべき問題は `A * B * x = lambda * x` です。`itype = 3` の場合、解くべき問題は `B * A * x = lambda * x` です。

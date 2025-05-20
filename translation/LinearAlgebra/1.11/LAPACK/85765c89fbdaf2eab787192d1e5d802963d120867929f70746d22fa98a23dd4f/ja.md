```
trtrs!(uplo, trans, diag, A, B)
```

`A * X = B` を解きます（`trans = N`）、`transpose(A) * X = B`（`trans = T`）、または `adjoint(A) * X = B`（`trans = C）`、(上三角行列の場合は `uplo = U`、下三角行列の場合は `uplo = L`) の行列 `A` に対して。`diag = N` の場合、`A` は非単位対角要素を持ちます。`diag = U` の場合、`A` のすべての対角要素は1です。`B` は解 `X` で上書きされます。

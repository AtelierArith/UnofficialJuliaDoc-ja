```julia
trtrs!(uplo, trans, diag, A, B)
```

上三角行列の場合は `A * X = B`（`trans = N`）、下三角行列の場合は `transpose(A) * X = B`（`trans = T`）、または `adjoint(A) * X = B`（`trans = C`）を、三角行列 `A` に対して解きます（`uplo = U` が真なら上三角、`uplo = L` が真なら下三角）。`diag = N` の場合、`A` の対角要素は 1 ではありません。`diag = U` の場合、`A` の対角要素はすべて 1 です。`B` は解 `X` で上書きされます。

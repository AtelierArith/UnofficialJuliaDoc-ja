```julia
trtrs!(uplo, trans, diag, A, B)
```

上三角行列の場合は `uplo = U`、下三角行列の場合は `uplo = L` として、三角行列 `A` に対する `A * X = B`（`trans = N`）、`transpose(A) * X = B`（`trans = T`）、または `adjoint(A) * X = B`（`trans = C`）を解きます。`diag = N` の場合、`A` の対角要素は単位元ではありません。`diag = U` の場合、`A` の対角要素はすべて 1 です。`B` は、解 `X` で上書きされます。

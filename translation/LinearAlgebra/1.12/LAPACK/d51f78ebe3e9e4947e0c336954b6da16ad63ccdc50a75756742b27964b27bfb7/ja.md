```julia
trtrs!(uplo, trans, diag, A, B)
```

`A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、または `adjoint(A) * X = B` (`trans = C`) を解きます（`uplo = U` の場合は上三角行列、`uplo = L` の場合は下三角行列）。`diag = N` の場合、`A` は非単位対角要素を持ちます。`diag = U` の場合、`A` のすべての対角要素は1です。`B` は解 `X` で上書きされます。

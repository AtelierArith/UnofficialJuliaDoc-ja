```julia
trrfs!(uplo, trans, diag, A, B, X, Ferr, Berr) -> (Ferr, Berr)
```

`trtrs!`を用いて`X`を計算した後、`side = L`に対する解の誤差を推定します。対象は、`A * X = B`（`trans = N`）、`transpose(A) * X = B`（`trans = T`）、`adjoint(A) * X = B`（`trans = C`）、または右手系の`side = R` `X * A`に対応する方程式です。`uplo = U`の場合、`A`は上三角行列です。`uplo = L`の場合、`A`は下三角行列です。`diag = N`の場合、`A`の対角要素はすべて1ではありません。`diag = U`の場合、`A`の対角要素はすべて1です。`Ferr`と`Berr`は省略可能な入力です。`Ferr`は前進誤差、`Berr`は後退誤差で、いずれも成分ごとに評価されます。

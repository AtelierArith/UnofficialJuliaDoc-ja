```julia
trrfs!(uplo, trans, diag, A, B, X, Ferr, Berr) -> (Ferr, Berr)
```

`side = L` に対する `A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、`adjoint(A) * X = B` (`trans = C`) の解の誤差を推定します。または、`trtrs!` を使って `X` を計算した後、右手系の `side = R` `X * A` に対応する方程式の誤差を推定します。`uplo = U` の場合、`A` は上三角行列です。`uplo = L` の場合、`A` は下三角行列です。`diag = N` の場合、`A` の対角要素は単位元ではありません。`diag = U` の場合、`A` の対角要素はすべて 1 です。`Ferr` と `Berr` は省略可能な入力です。`Ferr` は前進誤差、`Berr` は後退誤差で、いずれも成分ごとの誤差です。

```julia
trrfs!(uplo, trans, diag, A, B, X, Ferr, Berr) -> (Ferr, Berr)
```

`A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、`adjoint(A) * X = B` (`trans = C`) の解の誤差を推定します。`side = L` の場合、または右側の `side = R` の場合、`X * A` の同等の方程式を計算した後に `X` を `trtrs!` を使用して計算します。`uplo = U` の場合、`A` は上三角行列です。`uplo = L` の場合、`A` は下三角行列です。`diag = N` の場合、`A` は単位でない対角要素を持ちます。`diag = U` の場合、`A` のすべての対角要素は1です。`Ferr` と `Berr` はオプションの入力です。`Ferr` は前方誤差で、`Berr` は後方誤差であり、それぞれ成分ごとです。

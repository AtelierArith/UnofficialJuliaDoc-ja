```julia
lowrankdowndate(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を用いて、コレスキー分解 `C` をダウンドデートします。`A = C.U'C.U` の場合、`CC = cholesky(C.U'C.U - v*v')` ですが、`CC` の計算では `O(n^2)` 演算のみを使用します。

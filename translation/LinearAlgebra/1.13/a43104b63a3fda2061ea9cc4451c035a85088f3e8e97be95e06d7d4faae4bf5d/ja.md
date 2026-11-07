```julia
lowrankdowndate(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を用いて、コレスキー分解 `C` をダウndateします。`A = C.U'C.U` の場合、`CC = cholesky(C.U'C.U - v*v')` ですが、`CC` の計算で使用する演算は `O(n^2)` のみです。

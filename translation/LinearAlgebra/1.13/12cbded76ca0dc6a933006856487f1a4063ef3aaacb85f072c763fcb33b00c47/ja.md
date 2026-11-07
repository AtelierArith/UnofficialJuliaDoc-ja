```julia
lowrankupdate(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を使って、コレスキー分解 `C` を更新します。`A = C.U'C.U` の場合は `CC = cholesky(C.U'C.U + v*v')` ですが、`CC` の計算では `O(n^2)` 演算しか使いません。

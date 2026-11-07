```julia
lowrankupdate!(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を使って、コレスキー分解 `C` を更新します。`A = C.U'C.U` の場合、`CC = cholesky(C.U'C.U + v*v')` ですが、`CC` の計算では `O(n^2)` 演算のみを使用します。入力の分解 `C` はインプレースで更新され、終了時には `C == CC` となります。計算中にベクトル `v` は破棄されます。

```julia
lowrankdowndate!(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を用いて、コレスキー分解 `C` をダウンドデートします。`A = C.U'C.U` の場合、`CC = cholesky(C.U'C.U - v*v')` ですが、`CC` の計算で使用する演算は `O(n^2)` のみです。入力の分解 `C` はその場で更新され、終了時には `C == CC` となります。計算中にベクトル `v` は破棄されます。

```julia
lowrankdowndate!(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` を用いて、コレスキー分解 `C` をダウンドデートします。`A = C.U'C.U` の場合、`CC = cholesky(C.U'C.U - v*v')` ですが、`CC` の計算で使用するのは `O(n^2)` 演算だけです。入力の分解 `C` はインプレースで更新され、処理終了時には `C == CC` となります。計算中にベクトル `v` は破棄されます。

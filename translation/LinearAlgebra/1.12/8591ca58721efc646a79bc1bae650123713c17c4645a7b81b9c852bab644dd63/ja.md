```julia
lowrankdowndate!(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

ベクトル `v` で Cholesky 分解 `C` をダウンドデートします。もし `A = C.U'C.U` ならば `CC = cholesky(C.U'C.U - v*v')` ですが、`CC` の計算は `O(n^2)` の操作のみを使用します。入力の分解 `C` はインプレースで更新され、終了時には `C == CC` となります。ベクトル `v` は計算中に破棄されます。

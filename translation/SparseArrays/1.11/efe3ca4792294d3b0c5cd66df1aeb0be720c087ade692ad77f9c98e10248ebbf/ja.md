```
unchecked_noalias_permute!(X::AbstractSparseMatrixCSC{Tv,Ti},
    A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
    q::AbstractVector{<:Integer}, C::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

基本的な使用法については[`permute!`](@ref)を参照してください。`X`、`A`、および`C`が互いにエイリアスしないことを前提とした`SparseMatrixCSC`に対して動作する`permute[!]`メソッドの親です。このメソッドは引数のチェックを行わないため、直接使用するのではなく、安全な子メソッド（`permute[!]`）を使用することをお勧めします。

このメソッドは2つの主要なステップで構成されています：(1) 列の順序を入れ替え（`Q`,`I[:,q]`）て、`A`を転置して中間結果`(AQ)^T`（`transpose(A[:,q])`）を`C`に生成します。(2) 列の順序を入れ替え（`P^T`, I[:,p]）て、中間結果`(AQ)^T`を転置して結果`((AQ)^T P^T)^T = PAQ`（`A[p,q]`）を`X`に生成します。

最初のステップは`halfperm!`の呼び出しであり、2番目は不必要な長さ`nnz(A)`の配列スイープと関連する列ポインタの再計算を回避する`halfperm!`のバリアントです。追加のアルゴリズム情報については[`halfperm!`](:func:SparseArrays.halfperm!)を参照してください。

また、`unchecked_aliasing_permute!`も参照してください。

```julia
unchecked_noalias_permute!(X::AbstractSparseMatrixCSC{Tv,Ti},
    A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
    q::AbstractVector{<:Integer}, C::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

基本的な使い方については[`permute!`](@ref)を参照してください。`SparseMatrixCSC`に対して動作する`permute[!]`メソッドの親メソッドであり、`X`、`A`、`C`のいずれも互いにエイリアスではないことを前提とします。このメソッドは引数のチェックを行わないため、直接使用するよりも、より安全な子メソッド（`permute[!]`）を使うことを推奨します。

このメソッドは、主に次の2つの手順で構成されます。(1) `A`の列を並べ替え（`Q`、`I[:,q]`）、転置して、中間結果`(AQ)^T`（`transpose(A[:,q])`）を`C`内に生成します。(2) 中間結果`(AQ)^T`の列を並べ替え（`P^T`、I[:,p]）、転置して、結果`((AQ)^T P^T)^T = PAQ`（`A[p,q]`）を`X`内に生成します。

最初の手順では`halfperm!`を呼び出します。2番目の手順は`halfperm!`の変形で、長さ`nnz(A)`の配列を不要に走査する処理と、それに伴う列ポインタの再計算を省きます。アルゴリズムの詳細については[`halfperm!`](:func:SparseArrays.halfperm!)を参照してください。

`unchecked_aliasing_permute!`も参照してください。

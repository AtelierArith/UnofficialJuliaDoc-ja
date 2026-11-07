```julia
unchecked_noalias_permute!(X::AbstractSparseMatrixCSC{Tv,Ti},
    A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
    q::AbstractVector{<:Integer}, C::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

基本的な使い方については [`permute!`](@ref) を参照してください。これは、`X`、`A`、`C` が互いにエイリアスでないことを前提に、`SparseMatrixCSC` を操作する `permute[!]` メソッド群の親メソッドです。このメソッドは引数の検査を行わないため、直接使用するよりも、安全性の高い子メソッド（`permute[!]`）を使用してください。

このメソッドは、主に次の2つのステップからなります。(1) `A` の列を並べ替え（`Q`,`I[:,q]`）、転置することで、中間結果 `(AQ)^T`（`transpose(A[:,q])`）を `C` に生成します。(2) 中間結果 `(AQ)^T` の列を並べ替え（`P^T`, I[:,p]）、転置することで、結果 `((AQ)^T P^T)^T = PAQ`（`A[p,q]`）を `X` に生成します。

第1ステップでは `halfperm!` を呼び出します。第2ステップは `halfperm!` の変種で、長さ `nnz(A)` の配列に対する不要な走査と、それに伴う列ポインタの再計算を回避します。アルゴリズムの詳細については [`halfperm!`](:func:SparseArrays.halfperm!) を参照してください。

`unchecked_aliasing_permute!` も参照してください。

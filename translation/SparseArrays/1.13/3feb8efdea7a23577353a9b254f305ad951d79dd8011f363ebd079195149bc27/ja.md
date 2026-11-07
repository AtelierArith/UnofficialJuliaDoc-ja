```julia
halfperm!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{TvA,Ti},
          q::AbstractVector{<:Integer}, f::Function = identity) where {Tv,TvA,Ti}
```

列を並べ替えて `A` を転置し、`A` の各要素に `f` を同時に適用して、結果 `(f(A)Q)^T`（`map(f, transpose(A[:,q]))`）を `X` に格納します。

`X` の要素型 `Tv` は、`f(::TvA)` と一致している必要があります。ここで、`A` の要素型は `TvA` です。`X` の次元は `transpose(A)` の次元（`size(X, 1) == size(A, 2)` および `size(X, 2) == size(A, 1)`）と一致している必要があります。また、`X` には、`A` 内で割り当て済みのすべてのエントリ（`length(rowvals(X)) >= nnz(A)` および `length(nonzeros(X)) >= nnz(A)`）を格納できるだけの容量が必要です。列置換 `q` の長さは、`A` の列数（`length(q) == size(A, 2)`）と一致している必要があります。

このメソッドは、[`SparseMatrixCSC`](@ref) に対する転置および置換操作を行う複数のメソッドの親メソッドです。このメソッドは引数の検査を行わないため、直接使用するよりも、安全性の高い子メソッド（`[c]transpose[!]`、`permute[!]`）を使用してください。

このメソッドは、F. Gustavson の論文「Two fast algorithms for sparse matrices: multiplication and permuted transposition」（ACM TOMS 4(3), 250–269, 1978）で説明されている `HALFPERM` アルゴリズムを実装しています。このアルゴリズムの実行時間は `O(size(A, 1), size(A, 2), nnz(A))` で、渡された領域以外の追加領域を必要としません。

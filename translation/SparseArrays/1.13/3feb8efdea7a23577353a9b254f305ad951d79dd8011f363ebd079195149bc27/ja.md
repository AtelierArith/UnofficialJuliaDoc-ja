```julia
halfperm!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{TvA,Ti},
          q::AbstractVector{<:Integer}, f::Function = identity) where {Tv,TvA,Ti}
```

`A`の列を並べ替えて転置し、`A`の各要素に`f`を適用しながら、その結果を`X`に格納します。結果は`(f(A)Q)^T`（`map(f, transpose(A[:,q]))`）です。

`X`の要素型`Tv`は、`f(::TvA)`と一致している必要があります。ここで、`A`の要素型は`TvA`です。`X`の次元は`transpose(A)`の次元（`size(X, 1) == size(A, 2)`および`size(X, 2) == size(A, 1)`）と一致している必要があります。また、`X`には、`A`内の割り当て済みエントリすべてを格納できるだけの容量が必要です（`length(rowvals(X)) >= nnz(A)`および`length(nonzeros(X)) >= nnz(A)`）。列置換`q`の長さは、`A`の列数（`length(q) == size(A, 2)`）と一致している必要があります。

このメソッドは、[`SparseMatrixCSC`](@ref)に対する転置および置換操作を行う複数のメソッドの親メソッドです。このメソッドは引数の検査を行わないため、直接使用するよりも、安全性の高い子メソッド（`[c]transpose[!]`、`permute[!]`）を使用してください。

このメソッドは、F. Gustavsonの論文「Two fast algorithms for sparse matrices: multiplication and permuted transposition」（ACM TOMS 4(3), 250–269, 1978）で説明されている`HALFPERM`アルゴリズムを実装しています。このアルゴリズムの実行時間は`O(size(A, 1), size(A, 2), nnz(A))`であり、渡された領域以外の追加領域を必要としません。

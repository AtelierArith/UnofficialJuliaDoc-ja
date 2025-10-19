```julia
permute!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti},
         p::AbstractVector{<:Integer}, q::AbstractVector{<:Integer},
         [C::AbstractSparseMatrixCSC{Tv,Ti}]) where {Tv,Ti}
```

行列 `A` を双方向に置換し、結果 `PAQ` (`A[p,q]`) を `X` に格納します。オプション引数 `C` が存在する場合、中間結果 `(AQ)^T` (`transpose(A[:,q])`) を `C` に格納します。`X`、`A`、および、存在する場合は `C` が互いにエイリアスしないことが必要です。結果 `PAQ` を `A` に戻すには、`X` を欠いた以下のメソッドを使用します：

```julia
permute!(A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
         q::AbstractVector{<:Integer}[, C::AbstractSparseMatrixCSC{Tv,Ti},
         [workcolptr::Vector{Ti}]]) where {Tv,Ti}
```

`X` の次元は `A` の次元と一致しなければなりません（`size(X, 1) == size(A, 1)` および `size(X, 2) == size(A, 2)`）、また `X` は `A` のすべての割り当てられたエントリを収容できるだけのストレージを持っていなければなりません（`length(rowvals(X)) >= nnz(A)` および `length(nonzeros(X)) >= nnz(A)`）。列置換 `q` の長さは `A` の列数と一致しなければなりません（`length(q) == size(A, 2)`）。行置換 `p` の長さは `A` の行数と一致しなければなりません（`length(p) == size(A, 1)`）。

`C` の次元は `transpose(A)` の次元と一致しなければなりません（`size(C, 1) == size(A, 2)` および `size(C, 2) == size(A, 1)`）、また `C` は `A` のすべての割り当てられたエントリを収容できるだけのストレージを持っていなければなりません（`length(rowvals(C)) >= nnz(A)` および `length(nonzeros(C)) >= nnz(A)`）。

追加の（アルゴリズム的な）情報や、引数チェックを省略したこれらのメソッドのバージョンについては、（エクスポートされていない）親メソッド `unchecked_noalias_permute!` および `unchecked_aliasing_permute!` を参照してください。

また [`permute`](@ref) も参照してください。

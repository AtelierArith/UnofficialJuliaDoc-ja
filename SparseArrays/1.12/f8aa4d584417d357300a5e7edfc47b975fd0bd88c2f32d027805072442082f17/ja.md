```julia
transpose!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

行列 `A` を転置し、行列 `X` に格納します。`size(X)` は `size(transpose(A))` と等しくなければなりません。必要に応じて、`X` の rowval と nzval のサイズ変更以外に追加のメモリは割り当てられません。

`halfperm!` を参照してください。

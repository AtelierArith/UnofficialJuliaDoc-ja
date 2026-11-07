```julia
transpose!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

行列 `A` を転置し、その結果を行列 `X` に格納します。`size(X)` は `size(transpose(A))` と等しくなければなりません。必要な場合に `X` の rowval と nzval のサイズを変更する以外に、追加のメモリは割り当てられません。

`halfperm!` を参照してください。

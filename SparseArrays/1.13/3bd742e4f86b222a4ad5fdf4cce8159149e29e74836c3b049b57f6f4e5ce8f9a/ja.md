```julia
rowcheck_index(A::AbstractSparseMatrixCSC, row::Integer, col::Integer)
```

A[row, col] に格納されている値かどうかを確認し、`rowvals(A)` 内の行インデックスを返します。戻り値は `(row_exists, row_ind)` で、`row_exists::Bool` は対応するインデックスに値が格納されているかどうかを示し、`row_ind` はそのインデックスです。`row_exists` が `false` の場合、`row_ind` は、部分配列 `@view rowvals(A)[nzrange(A, col)]` がソートされた状態を保つように、値を `rowvals(A)` に挿入すべき位置のインデックスです。

```
dropstored!(A::AbstractSparseMatrixCSC, i::Integer, j::Integer)
```

エントリ `A[i,j]` を `A` から削除します。もし `A[i,j]` が保存されていれば削除し、そうでなければ何もしません。

```jldoctest
julia> A = sparse([1 2; 0 0])
2×2 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 1  2
 ⋅  ⋅

julia> SparseArrays.dropstored!(A, 1, 2); A
2×2 SparseMatrixCSC{Int64, Int64} with 1 stored entry:
 1  ⋅
 ⋅  ⋅
```

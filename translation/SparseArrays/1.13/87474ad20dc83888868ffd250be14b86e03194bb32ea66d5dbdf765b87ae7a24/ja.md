```julia
dropstored!(A::AbstractSparseMatrixCSC, i::Integer, j::Integer)
```

`A` に `A[i,j]` が格納されている場合は、`A[i,j]` のエントリを削除します。格納されていない場合は何もしません。

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

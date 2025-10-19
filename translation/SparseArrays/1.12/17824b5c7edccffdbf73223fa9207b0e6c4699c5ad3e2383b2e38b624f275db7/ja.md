```julia
nnz(A)
```

スパース配列に格納されている（埋められた）要素の数を返します。

# 例

```jldoctest
julia> A = sparse(2I, 3, 3)
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 2  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  2

julia> nnz(A)
3
```

```julia
findnz(A::SparseMatrixCSC)
```

スパース行列 `A` における保存された（「構造的に非ゼロ」）値の行と列のインデックスを含むタプル `(I, J, V)` を返します。`I` と `J` はインデックスで、`V` は値のベクターです。

# 例

```jldoctest
julia> A = sparse([1 2 0; 0 0 3; 0 4 0])
3×3 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  2  ⋅
 ⋅  ⋅  3
 ⋅  4  ⋅

julia> findnz(A)
([1, 1, 3, 2], [1, 2, 2, 3], [1, 2, 4, 3])
```

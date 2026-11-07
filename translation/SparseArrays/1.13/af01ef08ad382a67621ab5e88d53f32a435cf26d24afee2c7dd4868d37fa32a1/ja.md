```julia
findnz(A::SparseMatrixCSC)
```

疎行列 `A` に格納されている（「構造的に非ゼロ」の）値の行インデックスと列インデックスをそれぞれ `I` と `J` とし、値のベクトルを `V` とするタプル `(I, J, V)` を返します。

# Examples

```jldoctest
julia> A = sparse([1 2 0; 0 0 3; 0 4 0])
3×3 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  2  ⋅
 ⋅  ⋅  3
 ⋅  4  ⋅

julia> findnz(A)
([1, 1, 3, 2], [1, 2, 2, 3], [1, 2, 4, 3])
```

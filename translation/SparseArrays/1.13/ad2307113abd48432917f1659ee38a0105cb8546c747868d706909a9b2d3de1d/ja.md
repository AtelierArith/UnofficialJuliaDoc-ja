```julia
fkeep!(f, A::AbstractSparseArray)
```

`f` が `true` を返す要素を `A` から保持します。`f` のシグネチャは次のとおりです。

```julia
f(i::Integer, [j::Integer,] x) -> Bool
```

ここで、`i` と `j` は要素の行インデックスと列インデックス、`x` は要素の値です。このメソッドは `A` を一度だけ走査するため、行列では `O(size(A, 2), nnz(A))` 時間、ベクトルでは `O(nnz(A))` 時間を要し、渡された領域以外の追加領域は必要としません。

# Examples

```jldoctest
julia> A = sparse(Diagonal([1, 2, 3, 4]))
4×4 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  ⋅  ⋅  ⋅
 ⋅  2  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  4

julia> SparseArrays.fkeep!((i, j, v) -> isodd(v), A)
4×4 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 1  ⋅  ⋅  ⋅
 ⋅  ⋅  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  ⋅
```

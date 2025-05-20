```
fkeep!(f, A::AbstractSparseArray)
```

`A`の要素のうち、テスト`f`が`true`を返すものを保持します。`f`のシグネチャは次のようになります。

```
f(i::Integer, [j::Integer,] x) -> Bool
```

ここで、`i`と`j`は要素の行と列のインデックス、`x`は要素の値です。このメソッドは`A`を一度だけスイープし、行列の場合は`O(size(A, 2), nnz(A))`時間、ベクトルの場合は`O(nnz(A))`時間を必要とし、渡されたもの以外の空間は必要ありません。

# 例

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

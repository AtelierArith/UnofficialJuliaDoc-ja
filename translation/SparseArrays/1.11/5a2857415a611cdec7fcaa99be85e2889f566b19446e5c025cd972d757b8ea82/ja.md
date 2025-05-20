```
spzeros([type,]m[,n])
```

長さ `m` のスパースベクトルまたはサイズ `m x n` のスパース行列を作成します。このスパース配列には非ゼロ値は含まれません。構築中に非ゼロ値のためのストレージは割り当てられません。タイプは指定されていない場合、デフォルトで [`Float64`](@ref) になります。

# 例

```jldoctest
julia> spzeros(3, 3)
3×3 SparseMatrixCSC{Float64, Int64} with 0 stored entries:
  ⋅    ⋅    ⋅
  ⋅    ⋅    ⋅
  ⋅    ⋅    ⋅

julia> spzeros(Float32, 4)
4-element SparseVector{Float32, Int64} with 0 stored entries
```

```julia
dropzeros(A::AbstractSparseMatrixCSC;)
```

`A`のコピーを生成し、そのコピーから保存された数値のゼロを削除します。

インプレースバージョンおよびアルゴリズム情報については、[`dropzeros!`](@ref)を参照してください。

# 例

```jldoctest
julia> A = sparse([1, 2, 3], [1, 2, 3], [1.0, 0.0, 1.0])
3×3 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
 1.0   ⋅    ⋅
  ⋅   0.0   ⋅
  ⋅    ⋅   1.0

julia> dropzeros(A)
3×3 SparseMatrixCSC{Float64, Int64} with 2 stored entries:
 1.0   ⋅    ⋅
  ⋅    ⋅    ⋅
  ⋅    ⋅   1.0
```

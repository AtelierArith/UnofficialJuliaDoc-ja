```julia
spzeros([type,]m[,n])
```

長さ `m` の疎ベクトル、またはサイズ `m x n` の疎行列を作成します。この疎配列には非ゼロ値は含まれません。構築時に非ゼロ値用のストレージは割り当てられません。型を指定しない場合、デフォルトは [`Float64`](@ref) です。

# Examples

```jldoctest
julia> spzeros(3, 3)
3×3 SparseMatrixCSC{Float64, Int64} with 0 stored entries:
  ⋅    ⋅    ⋅
  ⋅    ⋅    ⋅
  ⋅    ⋅    ⋅

julia> spzeros(Float32, 4)
4-element SparseVector{Float32, Int64} with 0 stored entries
```

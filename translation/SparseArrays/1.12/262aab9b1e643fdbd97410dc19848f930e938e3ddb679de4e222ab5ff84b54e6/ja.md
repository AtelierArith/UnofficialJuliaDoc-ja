```julia
sparse(A::Union{AbstractVector, AbstractMatrix})
```

ベクトルまたは行列 `A` をスパース配列に変換します。`A` の数値ゼロは構造ゼロに変換されます。

# 例

```jldoctest
julia> A = Matrix(1.0I, 3, 3)
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> sparse(A)
3×3 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
 1.0   ⋅    ⋅
  ⋅   1.0   ⋅
  ⋅    ⋅   1.0

julia> [1.0, 0.0, 1.0]
3-element Vector{Float64}:
 1.0
 0.0
 1.0

julia> sparse([1.0, 0.0, 1.0])
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  1.0
  [3]  =  1.0
```

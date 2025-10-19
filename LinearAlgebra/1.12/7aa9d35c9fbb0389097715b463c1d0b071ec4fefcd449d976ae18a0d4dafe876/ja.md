```julia
UnitUpperTriangular(A::AbstractMatrix)
```

行列 `A` の `UnitUpperTriangular` ビューを構築します。このようなビューは、`A` の [`eltype`](@ref) の [`oneunit`](@ref) を対角線上に持ちます。

# 例

```jldoctest
julia> A = [1.0 2.0 3.0; 4.0 5.0 6.0; 7.0 8.0 9.0]
3×3 Matrix{Float64}:
 1.0  2.0  3.0
 4.0  5.0  6.0
 7.0  8.0  9.0

julia> UnitUpperTriangular(A)
3×3 UnitUpperTriangular{Float64, Matrix{Float64}}:
 1.0  2.0  3.0
  ⋅   1.0  6.0
  ⋅    ⋅   1.0
```

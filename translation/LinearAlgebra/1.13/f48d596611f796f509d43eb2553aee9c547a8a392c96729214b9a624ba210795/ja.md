```julia
fillstored!(A::AbstractMatrix, x)
```

構造化行列 `A` の格納されているインデックスだけに、値 `x` を代入します。

# Example

```jldoctest
julia> A = Tridiagonal(zeros(2), zeros(3), zeros(2))
3×3 Tridiagonal{Float64, Vector{Float64}}:
 0.0  0.0   ⋅
 0.0  0.0  0.0
  ⋅   0.0  0.0

julia> LinearAlgebra.fillstored!(A, 2)
3×3 Tridiagonal{Float64, Vector{Float64}}:
 2.0  2.0   ⋅
 2.0  2.0  2.0
  ⋅   2.0  2.0
```

```julia
fillstored!(A::AbstractMatrix, x)
```

Fill only the stored indices of a structured matrix `A` with the value `x`.

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

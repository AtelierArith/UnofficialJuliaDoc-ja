```
LDLt <: Factorization
```

Matrix factorization type of the `LDLt` factorization of a real [`SymTridiagonal`](@ref) matrix `S` such that `S = L*Diagonal(d)*L'`, where `L` is a [`UnitLowerTriangular`](@ref) matrix and `d` is a vector. The main use of an `LDLt` factorization `F = ldlt(S)` is to solve the linear system of equations `Sx = b` with `F\b`. This is the return type of [`ldlt`](@ref), the corresponding matrix factorization function.

The individual components of the factorization `F::LDLt` can be accessed via `getproperty`:

| Component | Description                                 |
|:---------:|:------------------------------------------- |
|   `F.L`   | `L` (unit lower triangular) part of `LDLt`  |
|   `F.D`   | `D` (diagonal) part of `LDLt`               |
|  `F.Lt`   | `Lt` (unit upper triangular) part of `LDLt` |
|   `F.d`   | diagonal values of `D` as a `Vector`        |

# Examples

```jldoctest
julia> S = SymTridiagonal([3., 4., 5.], [1., 2.])
3×3 SymTridiagonal{Float64, Vector{Float64}}:
 3.0  1.0   ⋅
 1.0  4.0  2.0
  ⋅   2.0  5.0

julia> F = ldlt(S)
LDLt{Float64, SymTridiagonal{Float64, Vector{Float64}}}
L factor:
3×3 UnitLowerTriangular{Float64, SymTridiagonal{Float64, Vector{Float64}}}:
 1.0        ⋅         ⋅
 0.333333  1.0        ⋅
 0.0       0.545455  1.0
D factor:
3×3 Diagonal{Float64, Vector{Float64}}:
 3.0   ⋅        ⋅
  ⋅   3.66667   ⋅
  ⋅    ⋅       3.90909
```

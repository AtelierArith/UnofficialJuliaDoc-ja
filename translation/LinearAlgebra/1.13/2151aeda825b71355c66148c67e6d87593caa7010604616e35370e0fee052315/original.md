```julia
lu!(F::LU, pivot = RowMaximum(); check = true, allowsingular = false) -> LU
```

`lu!` is the same as [`lu`](@ref), but saves space by overwriting the input `F`, instead of creating a copy.

!!! compat "Julia 1.13"
    Reusing dense `LU` factorizations in `lu!` require Julia 1.13 or later.


# Examples

```jldoctest
julia> A = [4. 3.; 6. 3.]
2×2 Matrix{Float64}:
 4.0  3.0
 6.0  3.0

julia> F = lu(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 6.0  3.0
 0.0  1.0

julia> B = [8 3; 12 3]
2×2 Matrix{Int64}:
  8  3
 12  3

julia> F2 = lu!(F,B)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 12.0  3.0
  0.0  1.0
```

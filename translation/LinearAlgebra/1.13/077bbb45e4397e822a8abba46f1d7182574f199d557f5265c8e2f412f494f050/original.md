```julia
eigvals!(A, B; sortby) -> values
```

Same as [`eigvals`](@ref), but saves space by overwriting the input `A` (and `B`), instead of creating copies.

!!! note
    The input matrices `A` and `B` will not contain their eigenvalues after `eigvals!` is called. They are used as workspaces.


# Examples

```jldoctest
julia> A = [1. 0.; 0. -1.]
2×2 Matrix{Float64}:
 1.0   0.0
 0.0  -1.0

julia> B = [0. 1.; 1. 0.]
2×2 Matrix{Float64}:
 0.0  1.0
 1.0  0.0

julia> eigvals!(A, B)
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im

julia> A
2×2 Matrix{Float64}:
 -0.0  -1.0
  1.0  -0.0

julia> B
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
```

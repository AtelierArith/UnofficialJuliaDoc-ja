```julia
fillband!(A::AbstractMatrix, x, l, u)
```

Fill the band between diagonals `l` and `u` with the value `x`.

# Examples

```jldoctest
julia> A = zeros(4,4)
4×4 Matrix{Float64}:
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0

julia> LinearAlgebra.fillband!(A, 2, 0, 1)
4×4 Matrix{Float64}:
 2.0  2.0  0.0  0.0
 0.0  2.0  2.0  0.0
 0.0  0.0  2.0  2.0
 0.0  0.0  0.0  2.0
```

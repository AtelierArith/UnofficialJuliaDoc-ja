```julia
sincos(A::AbstractMatrix)
```

Compute the matrix sine and cosine of a square matrix `A`.

# Examples

```jldoctest
julia> S, C = sincos(fill(1.0, (2,2)));

julia> S
2×2 Matrix{Float64}:
 0.454649  0.454649
 0.454649  0.454649

julia> C
2×2 Matrix{Float64}:
  0.291927  -0.708073
 -0.708073   0.291927
```

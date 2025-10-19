```julia
Schur <: Factorization
```

Matrix factorization type of the Schur factorization of a matrix `A`. This is the return type of [`schur(_)`](@ref), the corresponding matrix factorization function.

If `F::Schur` is the factorization object, the (quasi) triangular Schur factor can be obtained via either `F.Schur` or `F.T` and the orthogonal/unitary Schur vectors via `F.vectors` or `F.Z` such that `A = F.vectors * F.Schur * F.vectors'`. The eigenvalues of `A` can be obtained with `F.values`.

Iterating the decomposition produces the components `F.T`, `F.Z`, and `F.values`.

# Examples

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> F = schur(A)
Schur{Float64, Matrix{Float64}, Vector{Float64}}
T factor:
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
Z factor:
2×2 Matrix{Float64}:
  0.961524  0.274721
 -0.274721  0.961524
eigenvalues:
2-element Vector{Float64}:
  3.0
 -2.0

julia> F.vectors * F.Schur * F.vectors'
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> t, z, vals = F; # destructuring via iteration

julia> t == F.T && z == F.Z && vals == F.values
true
```

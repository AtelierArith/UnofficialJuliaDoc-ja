```
LU <: Factorization
```

Matrix factorization type of the `LU` factorization of a square matrix `A`. This is the return type of [`lu`](@ref), the corresponding matrix factorization function.

The individual components of the factorization `F::LU` can be accessed via [`getproperty`](@ref):

| Component | Description                              |
|:--------- |:---------------------------------------- |
| `F.L`     | `L` (unit lower triangular) part of `LU` |
| `F.U`     | `U` (upper triangular) part of `LU`      |
| `F.p`     | (right) permutation `Vector`             |
| `F.P`     | (right) permutation `Matrix`             |

Iterating the factorization produces the components `F.L`, `F.U`, and `F.p`.

# Examples

```jldoctest
julia> A = [4 3; 6 3]
2×2 Matrix{Int64}:
 4  3
 6  3

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

julia> F.L * F.U == A[F.p, :]
true

julia> l, u, p = lu(A); # destructuring via iteration

julia> l == F.L && u == F.U && p == F.p
true
```

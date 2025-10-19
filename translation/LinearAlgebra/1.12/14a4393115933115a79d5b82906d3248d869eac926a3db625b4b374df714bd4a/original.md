```julia
det(M)
```

Matrix determinant.

See also: [`logdet`](@ref) and [`logabsdet`](@ref).

# Examples

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> det(M)
2.0
```

Note that, in general, `det` computes a floating-point approximation of the determinant, even for integer matrices, typically via Gaussian elimination. Julia includes an exact algorithm for integer determinants (the Bareiss algorithm), but only uses it by default for `BigInt` matrices (since determinants quickly overflow any fixed integer precision):

```jldoctest
julia> det(BigInt[1 0; 2 2]) # exact integer determinant
2
```

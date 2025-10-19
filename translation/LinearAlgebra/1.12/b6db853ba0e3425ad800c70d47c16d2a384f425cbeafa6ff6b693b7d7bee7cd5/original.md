```julia
asin(A::AbstractMatrix)
```

Compute the inverse matrix sine of a square matrix `A`.

If `A` is symmetric or Hermitian, its eigendecomposition ([`eigen`](@ref)) is used to compute the inverse sine. Otherwise, the inverse sine is determined by using [`log`](@ref) and [`sqrt`](@ref).  For the theory and logarithmic formulas used to compute this function, see [^AH16_2].

[^AH16_2]: Mary Aprahamian and Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# Examples

```julia-repl
julia> asin(sin([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5-4.16334e-17im  0.1-5.55112e-17im
 -0.2+9.71445e-17im  0.3-1.249e-16im
```

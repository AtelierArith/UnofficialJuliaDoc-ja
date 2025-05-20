```
acos(A::AbstractMatrix)
```

Compute the inverse matrix cosine of a square matrix `A`.

If `A` is symmetric or Hermitian, its eigendecomposition ([`eigen`](@ref)) is used to compute the inverse cosine. Otherwise, the inverse cosine is determined by using [`log`](@ref) and [`sqrt`](@ref).  For the theory and logarithmic formulas used to compute this function, see [^AH16_1].

[^AH16_1]: Mary Aprahamian and Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# Examples

```julia-repl
julia> acos(cos([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5-8.32667e-17im  0.1+0.0im
 -0.2+2.63678e-16im  0.3-3.46945e-16im
```

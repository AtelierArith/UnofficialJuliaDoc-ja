```julia
log(A::AbstractMatrix)
```

If `A` has no negative real eigenvalue, compute the principal matrix logarithm of `A`, i.e. the unique matrix $X$ such that $e^X = A$ and $-\pi < Im(\lambda) < \pi$ for all the eigenvalues $\lambda$ of $X$. If `A` has nonpositive eigenvalues, a nonprincipal matrix function is returned whenever possible.

If `A` is symmetric or Hermitian, its eigendecomposition ([`eigen`](@ref)) is used, if `A` is triangular an improved version of the inverse scaling and squaring method is employed (see [^AH12] and [^AHR13]). If `A` is real with no negative eigenvalues, then the real Schur form is computed. Otherwise, the complex Schur form is computed. Then the upper (quasi-)triangular algorithm in [^AHR13] is used on the upper (quasi-)triangular factor.

[^AH12]: Awad H. Al-Mohy and Nicholas J. Higham, "Improved inverse  scaling and squaring algorithms for the matrix logarithm", SIAM Journal on Scientific Computing, 34(4), 2012, C153-C169. [doi:10.1137/110852553](https://doi.org/10.1137/110852553)

[^AHR13]: Awad H. Al-Mohy, Nicholas J. Higham and Samuel D. Relton, "Computing the Fréchet derivative of the matrix logarithm and estimating the condition number", SIAM Journal on Scientific Computing, 35(4), 2013, C394-C410. [doi:10.1137/120885991](https://doi.org/10.1137/120885991)

# Examples

```jldoctest
julia> A = Matrix(2.7182818*I, 2, 2)
2×2 Matrix{Float64}:
 2.71828  0.0
 0.0      2.71828

julia> log(A)
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
```

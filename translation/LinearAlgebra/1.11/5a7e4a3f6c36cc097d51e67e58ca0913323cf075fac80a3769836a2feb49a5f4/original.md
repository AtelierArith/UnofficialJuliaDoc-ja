```
cbrt(A::AbstractMatrix{<:Real})
```

Computes the real-valued cube root of a real-valued matrix `A`. If `T = cbrt(A)`, then we have `T*T*T ≈ A`, see example given below.

If `A` is symmetric, i.e., of type `HermOrSym{<:Real}`, then ([`eigen`](@ref)) is used to find the cube root. Otherwise, a specialized version of the p-th root algorithm [^S03] is utilized, which exploits the real-valued Schur decomposition ([`schur`](@ref)) to compute the cube root.

[^S03]: Matthew I. Smith, "A Schur Algorithm for Computing Matrix pth Roots", SIAM Journal on Matrix Analysis and Applications, vol. 24, 2003, pp. 971–989. [doi:10.1137/S0895479801392697](https://doi.org/10.1137/s0895479801392697)

# Examples

```jldoctest
julia> A = [0.927524 -0.15857; -1.3677 -1.01172]
2×2 Matrix{Float64}:
  0.927524  -0.15857
 -1.3677    -1.01172

julia> T = cbrt(A)
2×2 Matrix{Float64}:
  0.910077  -0.151019
 -1.30257   -0.936818

julia> T*T*T ≈ A
true
```

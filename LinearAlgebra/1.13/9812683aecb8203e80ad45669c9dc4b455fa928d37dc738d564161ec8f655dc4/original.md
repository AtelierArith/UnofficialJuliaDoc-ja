```julia
NoPivot
```

Pivoting is not performed. This is the default strategy for [`cholesky`](@ref) and [`qr`](@ref) factorizations. Note, however, that other matrix factorizations such as the LU factorization may fail without pivoting, and may also be numerically unstable for floating-point matrices in the face of roundoff error. In such cases, this pivot strategy is mainly useful for pedagogical purposes.

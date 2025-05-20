```
hermitianpart!(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

Overwrite the square matrix `A` in-place with its Hermitian part `(A + A') / 2`, and return [`Hermitian(A, uplo)`](@ref). For real matrices `A`, this is also known as the symmetric part of `A`.

See also [`hermitianpart`](@ref) for the corresponding out-of-place operation.

!!! compat "Julia 1.10"
    This function requires Julia 1.10 or later.


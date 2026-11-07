```julia
hermitianpart(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

Return the Hermitian part of the square matrix `A`, defined as `(A + A') / 2`, as a [`Hermitian`](@ref) matrix. For real matrices `A`, this is also known as the symmetric part of `A`; it is also sometimes called the "operator real part". The optional argument `uplo` controls the corresponding argument of the [`Hermitian`](@ref) view. For real matrices, the latter is equivalent to a [`Symmetric`](@ref) view.

See also [`hermitianpart!`](@ref) for the corresponding in-place operation.

!!! compat "Julia 1.10"
    This function requires Julia 1.10 or later.


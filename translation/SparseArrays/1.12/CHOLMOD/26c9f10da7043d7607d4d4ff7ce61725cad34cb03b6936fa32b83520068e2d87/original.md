```julia
cholesky!(F::CHOLMOD.Factor, A::SparseMatrixCSC; shift = 0.0, check = true) -> CHOLMOD.Factor
```

Compute the Cholesky ($LL'$) factorization of `A`, reusing the symbolic factorization `F`. `A` must be a [`SparseMatrixCSC`](@ref) or a [`Symmetric`](@ref)/ [`Hermitian`](@ref) view of a `SparseMatrixCSC`. Note that even if `A` doesn't have the type tag, it must still be symmetric or Hermitian.

See also [`cholesky`](@ref).

!!! note
    This method uses the CHOLMOD library from SuiteSparse, which only supports real or complex types in single or double precision. Input matrices not of those element types will be converted to these types as appropriate.


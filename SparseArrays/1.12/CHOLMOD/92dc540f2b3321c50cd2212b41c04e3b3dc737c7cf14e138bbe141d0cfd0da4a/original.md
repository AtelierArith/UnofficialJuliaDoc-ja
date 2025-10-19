```julia
ldlt(A::SparseMatrixCSC; shift = 0.0, check = true, perm=nothing) -> CHOLMOD.Factor
```

Compute the $LDL'$ factorization of a sparse matrix `A`. `A` must be a [`SparseMatrixCSC`](@ref) or a [`Symmetric`](@ref)/[`Hermitian`](@ref) view of a `SparseMatrixCSC`. Note that even if `A` doesn't have the type tag, it must still be symmetric or Hermitian. A fill-reducing permutation is used. `F = ldlt(A)` is most frequently used to solve systems of equations `A*x = b` with `F\b`. The returned factorization object `F` also supports the methods [`diag`](@ref), [`det`](@ref), [`logdet`](@ref), and [`inv`](@ref). You can extract individual factors from `F` using `F.L`. However, since pivoting is on by default, the factorization is internally represented as `A == P'*L*D*L'*P` with a permutation matrix `P`; using just `L` without accounting for `P` will give incorrect answers. To include the effects of permutation, it is typically preferable to extract "combined" factors like `PtL = F.PtL` (the equivalent of `P'*L`) and `LtP = F.UP` (the equivalent of `L'*P`). The complete list of supported factors is `:L, :PtL, :D, :UP, :U, :LD, :DU, :PtLD, :DUP`.

Unlike the related Cholesky factorization, the $LDL'$ factorization does not require `A` to be positive definite. However, it still requires all leading principal minors to be well-conditioned and will fail if this is not satisfied.

When `check = true`, an error is thrown if the decomposition fails. When `check = false`, responsibility for checking the decomposition's validity (via [`issuccess`](@ref)) lies with the user.

Setting the optional `shift` keyword argument computes the factorization of `A+shift*I` instead of `A`. If the `perm` argument is provided, it should be a permutation of `1:size(A,1)` giving the ordering to use (instead of CHOLMOD's default AMD ordering).

See also [`cholesky`](@ref) for a factorization that can be significantly faster than `ldlt`, but requires `A` to be positive definite.

!!! note
    This method uses the CHOLMOD[^ACM887][^DavisHager2009] library from [SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse). CHOLMOD only supports real or complex types in single or double precision. Input matrices not of those element types will be converted to these types as appropriate.

    Many other functions from CHOLMOD are wrapped but not exported from the `Base.SparseArrays.CHOLMOD` module.


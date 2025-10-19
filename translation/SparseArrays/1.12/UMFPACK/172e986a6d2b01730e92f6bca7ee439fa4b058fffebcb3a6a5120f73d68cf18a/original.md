```julia
lu(A::AbstractSparseMatrixCSC; check = true, q = nothing, control = get_umfpack_control()) -> F::UmfpackLU
```

Compute the LU factorization of a sparse matrix `A`.

For sparse `A` with real or complex element type, the return type of `F` is `UmfpackLU{Tv, Ti}`, with `Tv` = [`Float64`](@ref) or `ComplexF64` respectively and `Ti` is an integer type ([`Int32`](@ref) or [`Int64`](@ref)).

When `check = true`, an error is thrown if the decomposition fails. When `check = false`, responsibility for checking the decomposition's validity (via [`issuccess`](@ref)) lies with the user.

The permutation `q` can either be a permutation vector or `nothing`. If no permutation vector is provided or `q` is `nothing`, UMFPACK's default is used. If the permutation is not zero-based, a zero-based copy is made.

The `control` vector defaults to the Julia SparseArrays package's default configuration for UMFPACK (NB: this is modified from the UMFPACK defaults to disable iterative refinement), but can be changed by passing a vector of length `UMFPACK_CONTROL`, see the UMFPACK manual for possible configurations.  For example to reenable iterative refinement:

```julia
umfpack_control = SparseArrays.UMFPACK.get_umfpack_control(Float64, Int64) # read Julia default configuration for a Float64 sparse matrix
SparseArrays.UMFPACK.show_umf_ctrl(umfpack_control) # optional - display values
umfpack_control[SparseArrays.UMFPACK.JL_UMFPACK_IRSTEP] = 2.0 # reenable iterative refinement (2 is UMFPACK default max iterative refinement steps)

Alu = lu(A; control = umfpack_control)
x = Alu \ b   # solve Ax = b, including UMFPACK iterative refinement
```

The individual components of the factorization `F` can be accessed by indexing:

| Component | Description                         |
|:--------- |:----------------------------------- |
| `L`       | `L` (lower triangular) part of `LU` |
| `U`       | `U` (upper triangular) part of `LU` |
| `p`       | right permutation `Vector`          |
| `q`       | left permutation `Vector`           |
| `Rs`      | `Vector` of scaling factors         |
| `:`       | `(L,U,p,q,Rs)` components           |

The relation between `F` and `A` is

`F.L*F.U == (F.Rs .* A)[F.p, F.q]`

`F` further supports the following functions:

  * [`\`](@ref)
  * [`det`](@ref)

See also [`lu!`](@ref)

!!! note
    `lu(A::AbstractSparseMatrixCSC)` uses the UMFPACK[^ACM832] library that is part of [SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse). As this library only supports sparse matrices with [`Float64`](@ref) or `ComplexF64` elements, `lu` converts `A` into a copy that is of type `SparseMatrixCSC{Float64}` or `SparseMatrixCSC{ComplexF64}` as appropriate.


[^ACM832]: Davis, Timothy A. (2004b). Algorithm 832: UMFPACK V4.3–-an Unsymmetric-Pattern Multifrontal Method. ACM Trans. Math. Softw., 30(2), 196–199. [doi:10.1145/992200.992206](https://doi.org/10.1145/992200.992206)

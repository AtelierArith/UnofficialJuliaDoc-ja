```julia
lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC; check=true, reuse_symbolic=true, q=nothing) -> F::UmfpackLU
```

Compute the LU factorization of a sparse matrix `A`, reusing the symbolic factorization of an already existing LU factorization stored in `F`. Unless `reuse_symbolic` is set to false, the sparse matrix `A` must have an identical nonzero pattern as the matrix used to create the LU factorization `F`, otherwise an error is thrown. If the size of `A` and `F` differ, all vectors will be resized accordingly.

When `check = true`, an error is thrown if the decomposition fails. When `check = false`, responsibility for checking the decomposition's validity (via [`issuccess`](@ref)) lies with the user.

The permutation `q` can either be a permutation vector or `nothing`. If no permutation vector is provided or `q` is `nothing`, UMFPACK's default is used. If the permutation is not zero based, a zero based copy is made.

See also [`lu`](@ref)

!!! note
    `lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC)` uses the UMFPACK library that is part of SuiteSparse. As this library only supports sparse matrices with [`Float64`](@ref) or `ComplexF64` elements, `lu!` will automatically convert the types to those set by the LU factorization or `SparseMatrixCSC{ComplexF64}` as appropriate.


!!! compat "Julia 1.5"
    `lu!` for `UmfpackLU` requires at least Julia 1.5.


# Examples

```jldoctest
julia> A = sparse(Float64[1.0 2.0; 0.0 3.0]);

julia> F = lu(A);

julia> B = sparse(Float64[1.0 1.0; 0.0 1.0]);

julia> lu!(F, B);

julia> F \ ones(2)
2-element Vector{Float64}:
 0.0
 1.0
```

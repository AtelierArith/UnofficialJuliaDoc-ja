```
qr(A, pivot = NoPivot(); blocksize) -> F
```

Compute the QR factorization of the matrix `A`: an orthogonal (or unitary if `A` is complex-valued) matrix `Q`, and an upper triangular matrix `R` such that

$$
A = Q R
$$

The returned object `F` stores the factorization in a packed format:

  * if `pivot == ColumnNorm()` then `F` is a [`QRPivoted`](@ref) object,
  * otherwise if the element type of `A` is a BLAS type ([`Float32`](@ref), [`Float64`](@ref), `ComplexF32` or `ComplexF64`), then `F` is a [`QRCompactWY`](@ref) object,
  * otherwise `F` is a [`QR`](@ref) object.

The individual components of the decomposition `F` can be retrieved via property accessors:

  * `F.Q`: the orthogonal/unitary matrix `Q`
  * `F.R`: the upper triangular matrix `R`
  * `F.p`: the permutation vector of the pivot ([`QRPivoted`](@ref) only)
  * `F.P`: the permutation matrix of the pivot ([`QRPivoted`](@ref) only)

!!! note
    Each reference to the upper triangular factor via `F.R` allocates a new array. It is therefore advisable to cache that array, say, by `R = F.R` and continue working with `R`.


Iterating the decomposition produces the components `Q`, `R`, and if extant `p`.

The following functions are available for the `QR` objects: [`inv`](@ref), [`size`](@ref), and [`\`](@ref). When `A` is rectangular, `\` will return a least squares solution and if the solution is not unique, the one with smallest norm is returned. When `A` is not full rank, factorization with (column) pivoting is required to obtain a minimum norm solution.

Multiplication with respect to either full/square or non-full/square `Q` is allowed, i.e. both `F.Q*F.R` and `F.Q*A` are supported. A `Q` matrix can be converted into a regular matrix with [`Matrix`](@ref). This operation returns the "thin" Q factor, i.e., if `A` is `m`×`n` with `m>=n`, then `Matrix(F.Q)` yields an `m`×`n` matrix with orthonormal columns.  To retrieve the "full" Q factor, an `m`×`m` orthogonal matrix, use `F.Q*I` or `collect(F.Q)`. If `m<=n`, then `Matrix(F.Q)` yields an `m`×`m` orthogonal matrix.

The block size for QR decomposition can be specified by keyword argument `blocksize :: Integer` when `pivot == NoPivot()` and `A isa StridedMatrix{<:BlasFloat}`. It is ignored when `blocksize > minimum(size(A))`. See [`QRCompactWY`](@ref).

!!! compat "Julia 1.4"
    The `blocksize` keyword argument requires Julia 1.4 or later.


# Examples

```jldoctest
julia> A = [3.0 -6.0; 4.0 -8.0; 0.0 1.0]
3×2 Matrix{Float64}:
 3.0  -6.0
 4.0  -8.0
 0.0   1.0

julia> F = qr(A)
LinearAlgebra.QRCompactWY{Float64, Matrix{Float64}, Matrix{Float64}}
Q factor: 3×3 LinearAlgebra.QRCompactWYQ{Float64, Matrix{Float64}, Matrix{Float64}}
R factor:
2×2 Matrix{Float64}:
 -5.0  10.0
  0.0  -1.0

julia> F.Q * F.R == A
true
```

!!! note
    `qr` returns multiple types because LAPACK uses several representations that minimize the memory storage requirements of products of Householder elementary reflectors, so that the `Q` and `R` matrices can be stored compactly rather as two separate dense matrices.


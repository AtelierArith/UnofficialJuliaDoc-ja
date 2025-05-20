generic_bunchkaufman!(uplo, A, syhe, rook::Bool=false) -> LD<:AbstractMatrix, ipiv<:AbstractVector{Integer}, info::BlasInt

Computes the Bunch-Kaufman factorization of a symmetric or Hermitian matrix `A` of size `NxN` as `P'*U*D*U'*P` or `P'*L*D*L'*P`, depending on which triangle is stored in `A`. Note that if `A` is complex symmetric then `U'` and `L'` denote the unconjugated transposes, i.e. `transpose(U)` and `transpose(L)`. The resulting `U` or `L` and D are stored in-place in `A`, LAPACK style. `LD` is just a reference to `A` (that is, `LD===A`). `ipiv` stores the permutation information of the algorithm in LAPACK format. `info` indicates whether the factorization was successful and non-singular when `info==0`, or else `info` takes a different value. The outputs `LD`, `ipiv`, `info` follow the format of the LAPACK functions of the Bunch-Kaufman factorization (`dsytrf`, `csytrf`, `chetrf`, etc.), so this function can (ideally) be used interchangeably with its LAPACK counterparts `LAPACK.sytrf!`, `LAPACK.sytrf_rook!`, etc.

`uplo` is a character, either `'U'` or `'L'`, indicating whether the matrix is stored in the upper triangular part (`uplo=='U'`) or in the lower triangular part (`uplo=='L'`).

`syhe` is a character, either `'S'` or `'H'`, indicating whether the matrix is real/complex symmetric (`syhe=='S'`, and the symmetric Bunch-Kaufman factorization is performed) or complex hermitian (`syhe=='H'`, and the hermitian Bunch-Kaufman factorization is performed).

If `rook` is `true`, rook pivoting is used (also called bounded Bunch-Kaufman factorization). If `rook` is `false`, rook pivoting is not used (standard Bunch-Kaufman factorization). Rook pivoting can require up to `~N^3/6` extra comparisons in addition to the `~N^3/3` additions and `~N^3/3` multiplications of the standard Bunch-Kaufman factorization. However, rook pivoting guarantees that the entries of `U` or `L` are bounded.

This function implements the factorization algorithm entirely in native Julia, so it supports any number type representing real or complex numbers.

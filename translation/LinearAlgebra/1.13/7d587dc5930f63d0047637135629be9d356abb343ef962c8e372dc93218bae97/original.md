generic_adr1!(uplo, alpha, x, y, A, syhe) -> nothing

`generic_adr1!` performs the following adjoint (symmetric or Hermitian) rank 1 operation

`A[1:K,1:L] = alpha*x*y' + A[1:K,1:L]`

in-place, where `alpha` is a scalar, `x` is a K element vector, `y` is an L element vector and `A` is an `NxM` matrix. Note that `y'` can denote either the transpose, i.e. `transpose(y)` or the conjugate transpose , i.e. `adjoint(y)`.

`uplo` is a character, either `'U'`, `'L'` or `'F'`, indicating whether the matrix is stored in the upper triangular part (`uplo=='U'`), the lower triangular part (`uplo=='L'`), or the full storage space is used (`uplo=='F'`). If `uplo!='F'` then only the corresponding triangular part is updated. The values `'U'` or `'L'` can only be used when A is square (`N==M`).

`syhe` is a character, either `'S'` or `'H'`, indicating whether the symmetric adjoint (`syhe=='S'`, and `y'==transpose(y)`) or the hermitian adjoint (`syhe=='H'`, and `y'==adjoint(y)`) must be used.

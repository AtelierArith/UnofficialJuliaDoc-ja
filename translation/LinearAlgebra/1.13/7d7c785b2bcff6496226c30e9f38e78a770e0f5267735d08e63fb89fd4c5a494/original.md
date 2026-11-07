generic_mvpv!(trans, alpha, A, x, beta, y) -> nothing

`generic_mvpv!` performs the following matrix-vector operation:

`y[1:K] = alpha*A'*x[1:L] + beta*y[1:K]`

in-place, where `alpha` and `beta` are scalars, `x` is a vector with at least L elements, `y` is a vector with at least K elements, and `A` is an `NxM` matrix. `A'` can denote the transpose, i.e. `transpose(A)` or the conjugate transpose, i.e. `adjoint(A)`, and then `M==K && N==L`. `A'` can also denote no adjoining at all, i.e. `A'==A`, and then `N==K && M==L`.

`trans` is a character, either `'T'`, `'C'` or `'N'`, indicating whether `A'=transpose(A)`, `A'=adjoint(A)` or `A'=A`, respectively.

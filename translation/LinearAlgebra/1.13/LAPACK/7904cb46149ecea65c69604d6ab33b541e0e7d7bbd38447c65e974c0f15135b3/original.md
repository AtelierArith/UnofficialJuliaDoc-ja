```julia
hetrd!(uplo, A) -> (A, tau, d, e)
```

Converts a Hermitian matrix `A` to real-symmetric tridiagonal Hessenberg form. If `uplo = U`, the upper half of `A` is stored; if `uplo = L`, the lower half is stored. `tau` contains the elementary reflectors of the factorization, `d` contains the diagonal and `e` contains the upper/lower diagonal.

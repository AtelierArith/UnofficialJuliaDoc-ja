```
hseqr!(job, compz, ilo, ihi, H, Z) -> (H, Z, w)
```

Computes all eigenvalues and (optionally) the Schur factorization of a matrix reduced to Hessenberg form. If `H` is balanced with `gebal!` then `ilo` and `ihi` are the outputs of `gebal!`. Otherwise they should be `ilo = 1` and `ihi = size(H,2)`. `tau` contains the elementary reflectors of the factorization.

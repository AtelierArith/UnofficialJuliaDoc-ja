```
getrf!(A, ipiv) -> (A, ipiv, info)
```

Compute the pivoted `LU` factorization of `A`, `A = LU`. `ipiv` contains the pivoting information and `info` a code which indicates success (`info = 0`), a singular value in `U` (`info = i`, in which case `U[i,i]` is singular), or an error code (`info < 0`).

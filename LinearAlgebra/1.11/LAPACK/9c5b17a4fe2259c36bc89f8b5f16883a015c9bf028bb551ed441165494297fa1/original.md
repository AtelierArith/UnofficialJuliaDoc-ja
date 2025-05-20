```
getri!(A, ipiv)
```

Computes the inverse of `A`, using its `LU` factorization found by `getrf!`. `ipiv` is the pivot information output and `A` contains the `LU` factorization of `getrf!`. `A` is overwritten with its inverse.

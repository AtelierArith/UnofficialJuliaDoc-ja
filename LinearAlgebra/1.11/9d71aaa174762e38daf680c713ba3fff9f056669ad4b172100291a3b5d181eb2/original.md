```
lowrankdowndate(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

Downdate a Cholesky factorization `C` with the vector `v`. If `A = C.U'C.U` then `CC = cholesky(C.U'C.U - v*v')` but the computation of `CC` only uses `O(n^2)` operations.

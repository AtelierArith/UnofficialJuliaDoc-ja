```
lowrankupdate!(C::Cholesky, v::AbstractVector) -> CC::Cholesky
```

Update a Cholesky factorization `C` with the vector `v`. If `A = C.U'C.U` then `CC = cholesky(C.U'C.U + v*v')` but the computation of `CC` only uses `O(n^2)` operations. The input factorization `C` is updated in place such that on exit `C == CC`. The vector `v` is destroyed during the computation.

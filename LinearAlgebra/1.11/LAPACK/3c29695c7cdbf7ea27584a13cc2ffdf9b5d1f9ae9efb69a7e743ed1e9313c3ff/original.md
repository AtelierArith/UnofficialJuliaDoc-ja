```
gelsy!(A, B, rcond) -> (B, rnk)
```

Computes the least norm solution of `A * X = B` by finding the full `QR` factorization of `A`, then dividing-and-conquering the problem. `B` is overwritten with the solution `X`. Singular values below `rcond` will be treated as zero. Returns the solution in `B` and the effective rank of `A` in `rnk`.

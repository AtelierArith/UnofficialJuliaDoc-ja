```
geqrt!(A, nb) -> (A, T)
```

Compute the blocked `QR` factorization of `A`, `A = QR`. `nb` sets the block size and it must be between 1 and `n`, the second dimension of `A`.

Returns `A`, modified in-place, and `T`, which contains upper triangular block reflectors which parameterize the elementary reflectors of the factorization.

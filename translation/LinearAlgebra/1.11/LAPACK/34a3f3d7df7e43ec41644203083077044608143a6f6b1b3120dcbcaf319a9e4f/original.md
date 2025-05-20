```
geqrt!(A, T)
```

Compute the blocked `QR` factorization of `A`, `A = QR`. `T` contains upper triangular block reflectors which parameterize the elementary reflectors of the factorization. The first dimension of `T` sets the block size and it must be between 1 and `n`. The second dimension of `T` must equal the smallest dimension of `A`.

Returns `A` and `T` modified in-place.

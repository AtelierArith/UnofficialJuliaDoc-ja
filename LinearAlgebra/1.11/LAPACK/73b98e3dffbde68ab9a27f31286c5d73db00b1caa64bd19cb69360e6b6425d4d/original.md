```
geqp3!(A, [jpvt, tau]) -> (A, tau, jpvt)
```

Compute the pivoted `QR` factorization of `A`, `AP = QR` using BLAS level 3. `P` is a pivoting matrix, represented by `jpvt`. `tau` stores the elementary reflectors. The arguments `jpvt` and `tau` are optional and allow for passing preallocated arrays. When passed, `jpvt` must have length greater than or equal to `n` if `A` is an `(m x n)` matrix and `tau` must have length greater than or equal to the smallest dimension of `A`. On entry, if `jpvt[j]` does not equal zero then the `j`th column of `A` is permuted to the front of `AP`.

`A`, `jpvt`, and `tau` are modified in-place.

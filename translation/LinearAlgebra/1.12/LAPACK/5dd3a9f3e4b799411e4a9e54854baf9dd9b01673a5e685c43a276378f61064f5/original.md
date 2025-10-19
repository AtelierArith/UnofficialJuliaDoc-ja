```julia
geqrf!(A) -> (A, tau)
```

Compute the `QR` factorization of `A`, `A = QR`.

Returns `A`, modified in-place, and `tau`, which contains scalars which parameterize the elementary reflectors of the factorization.

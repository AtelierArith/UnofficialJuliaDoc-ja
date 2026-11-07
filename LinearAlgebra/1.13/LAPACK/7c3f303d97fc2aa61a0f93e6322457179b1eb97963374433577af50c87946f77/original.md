```julia
gerqf!(A, tau)
```

Compute the `RQ` factorization of `A`, `A = RQ`. `tau` contains scalars which parameterize the elementary reflectors of the factorization. `tau` must have length greater than or equal to the smallest dimension of `A`.

Returns `A` and `tau` modified in-place.

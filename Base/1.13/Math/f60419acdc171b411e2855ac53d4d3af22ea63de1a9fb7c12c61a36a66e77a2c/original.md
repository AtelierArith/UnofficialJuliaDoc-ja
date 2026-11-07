```julia
fromfraction(f::Int128)
```

Compute a tuple of values `(z1,z2)` such that     ``z1 + z2 == f / 2^128`` and the significand of `z1` has 27 trailing zeros.

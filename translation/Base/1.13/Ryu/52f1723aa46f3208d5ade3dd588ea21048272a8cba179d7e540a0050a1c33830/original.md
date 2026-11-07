```julia
Ryu.pow5split(T, i)
```

Compute `floor(5^i/2^k)`, where `k = pow5bits(i) - pow5_bitcount(T)`. The result is an unsigned integer twice as wide as `T` (i.e. a `UInt128` if `T == Float64`), with `pow5_bitcount(T)` significant bits.

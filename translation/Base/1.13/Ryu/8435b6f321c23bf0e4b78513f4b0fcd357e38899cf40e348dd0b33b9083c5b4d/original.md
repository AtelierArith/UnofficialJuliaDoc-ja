```julia
Ryu.pow5invsplit(T, i)
```

Compute `floor(2^k/5^i)+1`, where `k = pow5bits(i) - 1 + pow5_inv_bitcount(T)`. The result is an unsigned integer twice as wide as `T` (i.e. a `UInt128` if `T == Float64`), with `pow5_inv_bitcount(T)` significant bits.

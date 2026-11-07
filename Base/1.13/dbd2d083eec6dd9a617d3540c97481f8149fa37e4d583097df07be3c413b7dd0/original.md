```julia
zhi, zlo = add12(x, y)
```

A high-precision representation of `x + y` for floating-point numbers. Mathematically, `zhi + zlo = x + y`, where `zhi` contains the most significant bits and `zlo` the least significant.

Because of the way floating-point numbers are printed, `lo` may not look the way you might expect from the standpoint of decimal representation, even though it is exact from the standpoint of binary representation.

Example:

```jldoctest
julia> 1.0 + 1.0001e-15
1.000000000000001

julia> big(1.0) + big(1.0001e-15)
1.000000000000001000100000000000020165767380775934141445417482375879192346701529

julia> hi, lo = Base.add12(1.0, 1.0001e-15)
(1.000000000000001, -1.1012302462515652e-16)

julia> big(hi) + big(lo)
1.000000000000001000100000000000020165767380775934141445417482375879192346701529
```

`lo` differs from 1.0e-19 because `hi` is not exactly equal to the first 16 decimal digits of the answer.

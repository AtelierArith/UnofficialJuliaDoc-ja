```julia
zhi, zlo = mul12(x, y)
```

A high-precision representation of `x * y` for floating-point numbers. Mathematically, `zhi + zlo = x * y`, where `zhi` contains the most significant bits and `zlo` the least significant.

Example:

```jldoctest
julia> x = Float32(π)
3.1415927f0

julia> x * x
9.869605f0

julia> Float64(x) * Float64(x)
9.869604950382893

julia> hi, lo = Base.mul12(x, x)
(9.869605f0, -1.140092f-7)

julia> Float64(hi) + Float64(lo)
9.869604950382893
```

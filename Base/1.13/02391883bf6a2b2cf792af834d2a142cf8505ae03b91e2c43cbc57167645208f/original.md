```julia
zhi, zlo = div12(x, y)
```

A high-precision representation of `x / y` for floating-point numbers. Mathematically, `zhi + zlo ≈ x / y`, where `zhi` contains the most significant bits and `zlo` the least significant.

Example:

```jldoctest
julia> x, y = Float32(π), 3.1f0
(3.1415927f0, 3.1f0)

julia> x / y
1.013417f0

julia> Float64(x) / Float64(y)
1.0134170444063078

julia> hi, lo = Base.div12(x, y)
(1.013417f0, 3.8867366f-8)

julia> Float64(hi) + Float64(lo)
1.0134170444063066
```

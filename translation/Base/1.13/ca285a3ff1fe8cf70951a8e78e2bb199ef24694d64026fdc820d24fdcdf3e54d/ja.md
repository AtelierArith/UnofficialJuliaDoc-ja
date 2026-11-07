```julia
zhi, zlo = mul12(x, y)
```

浮動小数点数を高精度で表現するための `x * y` です。数学的には `zhi + zlo = x * y` であり、`zhi` が上位ビット、`zlo` が下位ビットを保持します。

例:

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

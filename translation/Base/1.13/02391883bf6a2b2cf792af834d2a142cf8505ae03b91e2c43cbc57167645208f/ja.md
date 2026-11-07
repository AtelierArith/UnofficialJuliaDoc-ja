```julia
zhi, zlo = div12(x, y)
```

浮動小数点数を高精度で表現する `x / y`。数学的には `zhi + zlo ≈ x / y` であり、`zhi` が最上位ビットを、`zlo` が最下位ビットを含む。

例：

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

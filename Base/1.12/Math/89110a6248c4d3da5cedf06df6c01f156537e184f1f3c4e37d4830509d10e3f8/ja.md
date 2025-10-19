```julia
sin(x::T) where {T <: Number} -> float(T)
```

`x`の正弦を計算します。`x`はラジアンで指定されます。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

他に[`sind`](@ref)、[`sinpi`](@ref)、[`sincos`](@ref)、[`cis`](@ref)、[`asin`](@ref)も参照してください。

# 例

```jldoctest
julia> round.(sin.(range(0, 2pi, length=9)'), digits=3)
1×9 Matrix{Float64}:
 0.0  0.707  1.0  0.707  0.0  -0.707  -1.0  -0.707  -0.0

julia> sind(45)
0.7071067811865476

julia> sinpi(1/4)
0.7071067811865475

julia> round.(sincos(pi/6), digits=3)
(0.5, 0.866)

julia> round(cis(pi/6), digits=3)
0.866 + 0.5im

julia> round(exp(im*pi/6), digits=3)
0.866 + 0.5im
```

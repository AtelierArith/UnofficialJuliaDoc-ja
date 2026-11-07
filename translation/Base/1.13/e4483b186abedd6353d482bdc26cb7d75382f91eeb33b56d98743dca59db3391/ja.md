```julia
eps(x::AbstractFloat)
```

`x` の *最下位桁の単位*（ulp）を返します。これは、`x` における、隣り合う表現可能な浮動小数点数の間の距離です。通常、`x` の両側で距離が異なる場合は、大きい方を採用します。つまり、

```julia
eps(x) == max(x-prevfloat(x), nextfloat(x)-x)
```

この規則の例外は、最小および最大の有限値（たとえば、`nextfloat(-Inf)` と `prevfloat(Inf)`（[`Float64`](@ref) の場合））です。これらの値では、小さい方の値に丸められます。

この動作の根拠は、`eps` が浮動小数点の丸め誤差の上限となることです。既定の丸めモードである `RoundNearest` のもとで、``y`` が実数であり、``x`` が ``y`` に最も近い浮動小数点数であるとすると、

```math
|y-x| \leq \operatorname{eps}(x)/2.
```

関連項目：[`nextfloat`](@ref)、[`issubnormal`](@ref)、[`floatmax`](@ref)。

# Examples

```jldoctest
julia> eps(1.0)
2.220446049250313e-16

julia> eps(prevfloat(2.0))
2.220446049250313e-16

julia> eps(2.0)
4.440892098500626e-16

julia> x = prevfloat(Inf)      # largest finite Float64
1.7976931348623157e308

julia> x + eps(x)/2            # rounds up
Inf

julia> x + prevfloat(eps(x)/2) # rounds down
1.7976931348623157e308
```

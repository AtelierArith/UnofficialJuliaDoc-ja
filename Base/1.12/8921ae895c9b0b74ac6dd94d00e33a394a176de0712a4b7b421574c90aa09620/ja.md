```julia
eps(x::AbstractFloat)
```

`x`の*最後の桁の単位*（ulp）を返します。これは、`x`での連続する表現可能な浮動小数点値の間の距離です。ほとんどの場合、`x`の両側の距離が異なる場合は、2つのうち大きい方が取られます。つまり、

```julia
eps(x) == max(x-prevfloat(x), nextfloat(x)-x)
```

このルールの例外は、最小および最大の有限値（例えば、[`Float64`](@ref)の`nextfloat(-Inf)`および`prevfloat(Inf)`）であり、これらは値の小さい方に丸められます。

この動作の理由は、`eps`が浮動小数点の丸め誤差を制限することです。デフォルトの`RoundNearest`丸めモードの下で、$y$が実数であり、$x$が$y$に最も近い浮動小数点数である場合、次の不等式が成り立ちます。

$$
|y-x| \leq \operatorname{eps}(x)/2.
$$

関連情報: [`nextfloat`](@ref), [`issubnormal`](@ref), [`floatmax`](@ref)。

# 例

```jldoctest
julia> eps(1.0)
2.220446049250313e-16

julia> eps(prevfloat(2.0))
2.220446049250313e-16

julia> eps(2.0)
4.440892098500626e-16

julia> x = prevfloat(Inf)      # 最大の有限Float64
1.7976931348623157e308

julia> x + eps(x)/2            # 切り上げ
Inf

julia> x + prevfloat(eps(x)/2) # 切り下げ
1.7976931348623157e308
```

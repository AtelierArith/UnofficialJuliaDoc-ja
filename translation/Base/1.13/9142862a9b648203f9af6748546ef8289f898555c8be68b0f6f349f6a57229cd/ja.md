```julia
nextfloat(x::AbstractFloat)
```

`x`と同じ型で、`x < y`を満たす最小の浮動小数点数`y`を返します。そのような`y`が存在しない場合（たとえば、`x`が`Inf`または`NaN`の場合）は、`x`を返します。

関連項目：[`prevfloat`](@ref)、[`eps`](@ref)、[`issubnormal`](@ref)。

```julia
cospi(x::T) where T -> float(T)
```

特に大きな`x`に対して、`cos(pi*x)`よりも正確に``\cos(\pi x)``を計算します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、そうでなければ`isnan(x)`の場合に`T(NaN)`を返します。

関連項目: [`cispi`](@ref)、[`sincosd`](@ref)、[`sinpi`](@ref)。

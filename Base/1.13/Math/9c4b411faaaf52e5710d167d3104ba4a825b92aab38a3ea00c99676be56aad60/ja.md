```julia
cospi(x::T) where T -> float(T)
```

特に大きな`x`については、`cos(pi*x)`よりも正確に``\cos(\pi x)``を計算します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

関連項目: [`cispi`](@ref)、[`sincosd`](@ref)、[`sinpi`](@ref)。

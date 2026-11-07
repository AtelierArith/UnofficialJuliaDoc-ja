```julia
sinpi(x::T) where T -> float(T)
```

特に大きな`x`では、`sin(pi*x)`よりも正確に``\sin(\pi x)``を計算します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

関連項目: [`sind`](@ref)、[`cospi`](@ref)、[`sincospi`](@ref)。

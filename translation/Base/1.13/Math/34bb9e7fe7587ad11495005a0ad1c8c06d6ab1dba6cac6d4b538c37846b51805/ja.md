```julia
tanpi(x::T) where T -> float(T)
```

``\tan(\pi x)``を、特に大きな`x`について、`tan(pi*x)`よりも高い精度で計算します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10以降が必要です。


関連項目: [`tand`](@ref)、[`sinpi`](@ref)、[`cospi`](@ref)、[`sincospi`](@ref)。

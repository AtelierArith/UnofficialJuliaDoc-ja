```julia
sinpi(x::T) where T -> float(T)
```

$$
\sin(\pi x)
$$

を`sin(pi*x)`よりも正確に計算します。特に大きな`x`に対して。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。

他に[`sind`](@ref)、[`cospi`](@ref)、[`sincospi`](@ref)も参照してください。

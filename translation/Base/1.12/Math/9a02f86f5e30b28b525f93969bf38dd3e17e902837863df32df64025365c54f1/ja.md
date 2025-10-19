```julia
cospi(x::T) where T -> float(T)
```

$$
\cos(\pi x)
$$

を`cos(pi*x)`よりも正確に計算します。特に大きな`x`に対して。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。

関連: [`cispi`](@ref), [`sincosd`](@ref), [`cospi`](@ref).

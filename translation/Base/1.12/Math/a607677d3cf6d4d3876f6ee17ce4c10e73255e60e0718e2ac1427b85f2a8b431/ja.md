```julia
tanpi(x::T) where T -> float(T)
```

$$
\tan(\pi x)
$$

を`tan(pi*x)`よりも正確に計算します。特に大きな`x`に対して。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。

!!! compat "Julia 1.10"
    この関数は少なくともJulia 1.10が必要です。


関連情報として[`tand`](@ref)、[`sinpi`](@ref)、[`cospi`](@ref)、[`sincospi`](@ref)を参照してください。

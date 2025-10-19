```julia
cos(x::T) where {T <: Number} -> float(T)
```

`x`がラジアンである場合のコサインを計算します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

他に[`cosd`](@ref)、[`cospi`](@ref)、[`sincos`](@ref)、[`cis`](@ref)も参照してください。

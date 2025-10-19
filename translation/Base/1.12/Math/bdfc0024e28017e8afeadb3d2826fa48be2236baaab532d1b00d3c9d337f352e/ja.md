```julia
tan(x::T) where {T <: Number} -> float(T)
```

`x`のタンジェントを計算します。`x`はラジアンである必要があります。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

他に[`tanh`](@ref)も参照してください。

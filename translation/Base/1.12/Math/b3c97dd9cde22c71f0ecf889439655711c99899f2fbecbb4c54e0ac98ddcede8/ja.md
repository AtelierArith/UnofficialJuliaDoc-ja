```julia
secd(x::T) where {T <: Number} -> float(T)
```

`x`のセカントを計算します。`x`は度数で指定されます。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。

```julia
cot(x::T) where {T <: Number} -> float(T)
```

`x`のコタンジェントを計算します。`x`はラジアンで指定されます。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

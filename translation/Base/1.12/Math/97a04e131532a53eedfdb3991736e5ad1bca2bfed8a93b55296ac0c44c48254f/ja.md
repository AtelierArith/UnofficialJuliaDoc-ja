```julia
cscd(x::T) where {T <: Number} -> float(T)
```

`x`の余弦の逆数を計算します。`x`は度数法で指定されます。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。

```julia
cscd(x::T) where {T <: Number} -> float(T)
```

`x` の余割を計算します。ここで、`x` は度数法で表されています。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

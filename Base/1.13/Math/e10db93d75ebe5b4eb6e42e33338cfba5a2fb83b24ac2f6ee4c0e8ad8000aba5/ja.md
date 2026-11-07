```julia
cotd(x::T) where {T <: Number} -> float(T)
```

`x` の余接を計算します。`x` は度数法で表されます。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

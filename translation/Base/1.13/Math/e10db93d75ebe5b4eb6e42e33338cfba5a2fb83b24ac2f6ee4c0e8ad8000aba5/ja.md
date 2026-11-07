```julia
cotd(x::T) where {T <: Number} -> float(T)
```

`x` が度数法で表されている場合、`x` の余接を計算します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

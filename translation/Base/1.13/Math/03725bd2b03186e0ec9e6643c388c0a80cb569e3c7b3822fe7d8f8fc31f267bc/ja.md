```julia
sec(x::T) where {T <: Number} -> float(T)
```

`x` の正割を計算します。`x` はラジアン単位です。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

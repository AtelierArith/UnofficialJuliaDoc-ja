```julia
cot(x::T) where {T <: Number} -> float(T)
```

`x` の余接を計算します。`x` はラジアン単位です。

[`DomainError`](@ref) をスローします（`isinf(x)` の場合）。`isnan(x)` の場合は `T(NaN)` を返します。

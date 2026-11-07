```julia
csc(x::T) where {T <: Number} -> float(T)
```

`x`（ラジアン単位）の `x` の余割を計算します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

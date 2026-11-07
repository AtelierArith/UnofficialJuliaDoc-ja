```julia
csc(x::T) where {T <: Number} -> float(T)
```

`x` の余割を計算します。`x` はラジアン単位です。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、そうでなければ `T(NaN)` を返します。`isnan(x)`

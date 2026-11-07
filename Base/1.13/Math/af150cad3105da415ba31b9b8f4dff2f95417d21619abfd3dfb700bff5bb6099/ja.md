```julia
cos(x::T) where {T <: Number} -> float(T)
```

`x` の余弦を計算します。`x` はラジアン単位です。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

関連項目: [`cosd`](@ref)、[`cospi`](@ref)、[`sincos`](@ref)、[`cis`](@ref)。

```julia
sincos(x::T) where T -> Tuple{float(T),float(T)}
```

`x` の正弦と余弦を同時に計算します。`x` はラジアン単位で、タプル `(sine, cosine)` を返します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `(T(NaN), T(NaN))` を返します。

関連項目: [`cis`](@ref)、[`sincospi`](@ref)、[`sincosd`](@ref)。

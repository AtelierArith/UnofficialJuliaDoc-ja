```julia
sincospi(x::T) where T -> Tuple{float(T),float(T)}
```

`π*x`（ラジアン単位では `x`）の正弦と余弦である [`sinpi(x)`](@ref) と [`cospi(x)`](@ref) を同時に計算し、タプル `(sine, cosine)` を返します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `(T(NaN), T(NaN))` タプルを返します。

!!! compat "Julia 1.6"
    この関数を使用するには、Julia 1.6 以降が必要です。


関連項目: [`cispi`](@ref)、[`sincosd`](@ref)、[`sinpi`](@ref)。

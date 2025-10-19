```julia
sincospi(x::T) where T -> Tuple{float(T),float(T)}
```

同時に [`sinpi(x)`](@ref) と [`cospi(x)`](@ref) を計算します（`x` がラジアンのときの `π*x` の正弦と余弦）、タプル `(sine, cosine)` を返します。

`isinf(x)` の場合は [`DomainError`](@ref) を投げ、`isnan(x)` の場合は `(T(NaN), T(NaN))` のタプルを返します。

!!! compat "Julia 1.6"
    この関数は Julia 1.6 以降が必要です。


関連: [`cispi`](@ref), [`sincosd`](@ref), [`sinpi`](@ref).

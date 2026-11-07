```julia
sinc(x::T) where {T <: Number} -> float(T)
```

``x \neq 0`` の場合は正規化 sinc 関数 ``\operatorname{sinc}(x) = \sin(\pi x) / (\pi x)`` を計算し、``x = 0`` の場合は ``1`` を計算します。

`isnan(x)` の場合は `T(NaN)` を返します。

関連項目: [`cosc`](@ref)（その導関数）。

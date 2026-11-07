```julia
sinc(x::T) where {T <: Number} -> float(T)
```

正規化 sinc 関数 ``\operatorname{sinc}(x) = \sin(\pi x) / (\pi x)`` を ``x \neq 0`` の場合に、また ``1`` を ``x = 0`` の場合に計算します。

`isnan(x)` の場合は `T(NaN)` を返します。

その導関数については [`cosc`](@ref) も参照してください。

```julia
sinc(x::T) where {T <: Number} -> float(T)
```

正規化されたsinc関数 $\operatorname{sinc}(x) = \sin(\pi x) / (\pi x)$ を計算します。$x \neq 0$ の場合、$1$ は $x = 0$ の場合です。

`isnan(x)` が真であれば `T(NaN)` を返します。

[`cosc`](@ref) およびその導関数も参照してください。

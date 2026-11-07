```julia
acos(x::T) where {T <: Number} -> float(T)
```

`x` の逆余弦を計算します。出力はラジアン単位です。

`isnan(x)` の場合は、`T(NaN)` を返します。

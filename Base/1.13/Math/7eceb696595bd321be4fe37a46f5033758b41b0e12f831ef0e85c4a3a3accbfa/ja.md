```julia
acos(x::T) where {T <: Number} -> float(T)
```

`x` の逆余弦を計算します。出力の単位はラジアンです。

`isnan(x)` の場合は、`T(NaN)` を返します。

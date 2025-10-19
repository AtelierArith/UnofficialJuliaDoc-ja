```julia
acos(x::T) where {T <: Number} -> float(T)
```

`x`の逆余弦を計算し、出力はラジアンで返します。

`isnan(x)`の場合は`T(NaN)`を返します。

```julia
csch(x::T) where {T <: Number} -> float(T)
```

`x` の双曲線余割を計算します。

`isnan(x)` の場合は、`T(NaN)` を返します。

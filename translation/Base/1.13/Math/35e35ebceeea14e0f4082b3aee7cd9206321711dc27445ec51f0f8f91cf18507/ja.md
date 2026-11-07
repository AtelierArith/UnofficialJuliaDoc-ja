```julia
coth(x::T) where {T <: Number} -> float(T)
```

`x` の双曲線余接を計算します。

`isnan(x)` の場合は、`T(NaN)` を返します。

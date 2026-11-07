```julia
sind(x::T) where T -> float(T)
```

`x`の正弦を計算します。`x`の単位は度です。`x`が行列の場合、`x`は正方行列である必要があります。

[`DomainError`](@ref)をスローします（`isinf(x)`の場合）。`isnan(x)`の場合は、`T(NaN)`を返します。

!!! compat "Julia 1.7"
    行列引数を使用するには、Julia 1.7以降が必要です。


```julia
cosd(x::T) where T -> float(T)
```

`x`の余弦を計算します。`x`の単位は度です。`x`が行列の場合、`x`は正方行列である必要があります。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

!!! compat "Julia 1.7"
    行列引数にはJulia 1.7以降が必要です。


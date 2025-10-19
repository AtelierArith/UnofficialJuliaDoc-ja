```julia
cosd(x::T) where T -> float(T)
```

`x`が度数である場合のコサインを計算します。`x`が行列の場合、`x`は正方行列である必要があります。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`T(NaN)`を返します。

!!! compat "Julia 1.7"
    行列引数はJulia 1.7以降が必要です。


```julia
tand(x::T) where T -> float(T)
```

`x` の正接を計算します。`x` は度数法で指定します。`x` が行列の場合、`x` は正方行列である必要があります。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `T(NaN)` を返します。

!!! compat "Julia 1.7"
    行列引数には Julia 1.7 以降が必要です。


```julia
expm1(x)
```

``e^x-1`` を高精度で計算します。x が小さい場合に exp(x) - 1 を直接計算すると生じる精度の損失を避けられます。

# Examples

```jldoctest
julia> expm1(1e-16)
1.0e-16

julia> exp(1e-16) - 1
0.0
```

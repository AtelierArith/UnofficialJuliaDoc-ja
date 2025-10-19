```julia
expm1(x)
```

$$
e^x-1
$$

を正確に計算します。これは、xの小さい値に対してexp(x)-1を直接評価する際に関わる精度の損失を回避します。

# 例

```jldoctest
julia> expm1(1e-16)
1.0e-16

julia> exp(1e-16) - 1
0.0
```

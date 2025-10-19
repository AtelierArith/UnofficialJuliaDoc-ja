```julia
γ
eulergamma
```

オイラー定数。

# 例

```jldoctest
julia> Base.MathConstants.eulergamma
γ = 0.5772156649015...

julia> dx = 10^-6;

julia> sum(-exp(-x) * log(x) for x in dx:dx:100) * dx
0.5772078382499133
```

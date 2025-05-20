```
cispi(x)
```

`cis(pi*x)` のより正確な方法（特に大きな `x` に対して）。

他に [`cis`](@ref)、[`sincospi`](@ref)、[`exp`](@ref)、[`angle`](@ref) も参照してください。

# 例

```jldoctest
julia> cispi(10000)
1.0 + 0.0im

julia> cispi(0.25 + 1im)
0.030556854645954562 + 0.03055685464595456im
```

!!! compat "Julia 1.6"
    この関数は Julia 1.6 以降が必要です。


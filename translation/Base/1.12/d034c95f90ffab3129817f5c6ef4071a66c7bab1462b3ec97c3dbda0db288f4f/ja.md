```julia
cispi(x)
```

`cis(pi*x)`のより正確な方法（特に大きな`x`の場合）。

関連項目としては、[`cis`](@ref)、[`sincospi`](@ref)、[`exp`](@ref)、[`angle`](@ref)があります。

# 例

```jldoctest
julia> cispi(10000)
1.0 + 0.0im

julia> cispi(0.25 + 1im)
0.030556854645954562 + 0.03055685464595456im
```

!!! compat "Julia 1.6"
    この関数はJulia 1.6以降が必要です。


```julia
cispi(x)
```

`cis(pi*x)`（特に大きな`x`の場合）に対して、より正確な方法です。

[`cis`](@ref)、[`sincospi`](@ref)、[`exp`](@ref)、[`angle`](@ref)も参照してください。

# Examples

```jldoctest
julia> cispi(10000)
1.0 + 0.0im

julia> cispi(0.25 + 1im)
0.030556854645954562 + 0.03055685464595456im
```

!!! compat "Julia 1.6"
    この関数を使用するには、Julia 1.6以降が必要です。


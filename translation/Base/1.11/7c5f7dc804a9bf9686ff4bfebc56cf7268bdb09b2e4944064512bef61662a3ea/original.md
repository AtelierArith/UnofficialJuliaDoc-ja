```
cispi(x)
```

More accurate method for `cis(pi*x)` (especially for large `x`).

See also [`cis`](@ref), [`sincospi`](@ref), [`exp`](@ref), [`angle`](@ref).

# Examples

```jldoctest
julia> cispi(10000)
1.0 + 0.0im

julia> cispi(0.25 + 1im)
0.030556854645954562 + 0.03055685464595456im
```

!!! compat "Julia 1.6"
    This function requires Julia 1.6 or later.


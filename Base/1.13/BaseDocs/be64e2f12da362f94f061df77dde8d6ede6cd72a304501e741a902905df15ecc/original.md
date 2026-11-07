```julia
/(x, y)
```

Right division operator: multiplication of `x` by the inverse of `y` on the right.

Gives floating-point results for integer arguments. See [`÷`](@ref div) for integer division, or [`//`](@ref) for [`Rational`](@ref) results.

# Examples

```jldoctest
julia> 1/2
0.5

julia> 4/2
2.0

julia> 4.5/2
2.25
```

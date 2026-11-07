```julia
isnegative(x)
```

Test whether `x < 0`. See also [`ispositive`](@ref).

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


# Examples

```jldoctest
julia> isnegative(-4.0)
true

julia> isnegative(99)
false

julia> isnegative(-0.0)
false
```

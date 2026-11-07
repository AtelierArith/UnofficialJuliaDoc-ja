```julia
ispositive(x)
```

Test whether `x > 0`. See also [`isnegative`](@ref).

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


# Examples

```jldoctest
julia> ispositive(-4.0)
false

julia> ispositive(99)
true

julia> ispositive(0.0)
false
```

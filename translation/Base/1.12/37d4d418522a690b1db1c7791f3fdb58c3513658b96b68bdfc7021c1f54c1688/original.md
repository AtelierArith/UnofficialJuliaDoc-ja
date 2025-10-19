```julia
isodd(x::Number) -> Bool
```

Return `true` if `x` is an odd integer (that is, an integer not divisible by 2), and `false` otherwise.

!!! compat "Julia 1.7"
    Non-`Integer` arguments require Julia 1.7 or later.


# Examples

```jldoctest
julia> isodd(9)
true

julia> isodd(10)
false
```

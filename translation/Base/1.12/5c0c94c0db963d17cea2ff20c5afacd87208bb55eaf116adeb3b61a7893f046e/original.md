```julia
iseven(x::Number) -> Bool
```

Return `true` if `x` is an even integer (that is, an integer divisible by 2), and `false` otherwise.

!!! compat "Julia 1.7"
    Non-`Integer` arguments require Julia 1.7 or later.


# Examples

```jldoctest
julia> iseven(9)
false

julia> iseven(10)
true
```

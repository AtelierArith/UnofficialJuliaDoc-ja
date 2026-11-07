```julia
RoundFromZero
```

Rounds away from zero.

!!! compat "Julia 1.9"
    `RoundFromZero` requires at least Julia 1.9. Prior versions support `RoundFromZero` for `BigFloat`s only.


# Examples

```jldoctest
julia> BigFloat("1.0000000000000001", 5, RoundFromZero)
1.06
```

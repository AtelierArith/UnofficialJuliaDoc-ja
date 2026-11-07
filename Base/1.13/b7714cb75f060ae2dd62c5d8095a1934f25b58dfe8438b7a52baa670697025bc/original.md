```julia
copysign(x, y) -> z
```

Return `z` which has the magnitude of `x` and the same sign as `y`.

# Examples

```jldoctest
julia> copysign(1, -2)
-1

julia> copysign(-1, 2)
1
```

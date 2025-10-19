```julia
isfinite(f) -> Bool
```

Test whether a number is finite.

# Examples

```jldoctest
julia> isfinite(5)
true

julia> isfinite(NaN32)
false
```

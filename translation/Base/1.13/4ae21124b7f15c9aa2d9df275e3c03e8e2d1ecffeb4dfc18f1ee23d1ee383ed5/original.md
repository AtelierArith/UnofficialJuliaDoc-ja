```julia
min(x, y, ...)
```

Return the minimum of the arguments, with respect to [`isless`](@ref). If any of the arguments is [`missing`](@ref), return `missing`. See also the [`minimum`](@ref) function to take the minimum element from a collection.

# Examples

```jldoctest
julia> min(2, 5, 1)
1

julia> min(4, missing, 6)
missing
```

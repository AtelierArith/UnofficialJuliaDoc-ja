```julia
max(x, y, ...)
```

Return the maximum of the arguments, with respect to [`isless`](@ref). If any of the arguments is [`missing`](@ref), return `missing`. See also the [`maximum`](@ref) function to take the maximum element from a collection.

# Examples

```jldoctest
julia> max(2, 5, 1)
5

julia> max(5, missing, 6)
missing
```

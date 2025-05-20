```
coalesce(x...)
```

Return the first value in the arguments which is not equal to [`missing`](@ref), if any. Otherwise return `missing`.

See also [`skipmissing`](@ref), [`something`](@ref), [`@coalesce`](@ref).

# Examples

```jldoctest
julia> coalesce(missing, 1)
1

julia> coalesce(1, missing)
1

julia> coalesce(nothing, 1)  # returns `nothing`

julia> coalesce(missing, missing)
missing
```

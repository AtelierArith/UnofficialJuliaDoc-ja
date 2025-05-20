```
something(x...)
```

Return the first value in the arguments which is not equal to [`nothing`](@ref), if any. Otherwise throw an error. Arguments of type [`Some`](@ref) are unwrapped.

See also [`coalesce`](@ref), [`skipmissing`](@ref), [`@something`](@ref).

# Examples

```jldoctest
julia> something(nothing, 1)
1

julia> something(Some(1), nothing)
1

julia> something(Some(nothing), 2) === nothing
true

julia> something(missing, nothing)
missing

julia> something(nothing, nothing)
ERROR: ArgumentError: No value arguments present
```

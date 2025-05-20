```
chopprefix(s::AbstractString, prefix::Union{AbstractString,Regex}) -> SubString
```

Remove the prefix `prefix` from `s`. If `s` does not start with `prefix`, a string equal to `s` is returned.

See also [`chopsuffix`](@ref).

!!! compat "Julia 1.8"
    This function is available as of Julia 1.8.


# Examples

```jldoctest
julia> chopprefix("Hamburger", "Ham")
"burger"

julia> chopprefix("Hamburger", "hotdog")
"Hamburger"
```

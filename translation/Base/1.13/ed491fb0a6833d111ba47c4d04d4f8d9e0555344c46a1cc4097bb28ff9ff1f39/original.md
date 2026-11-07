```julia
chopsuffix(s::AbstractString, suffix::Union{AbstractString,Regex,AbstractChar})::SubString
```

Remove the suffix `suffix` from `s`. If `s` does not end with `suffix`, a string equal to `s` is returned.

See also [`chopprefix`](@ref).

!!! compat "Julia 1.8"
    This function is available as of Julia 1.8.


!!! compat "Julia 1.13"
    The method which accepts an `AbstractChar` suffix is available as of Julia 1.13.


# Examples

```jldoctest
julia> chopsuffix("Hamburger", "er")
"Hamburg"

julia> chopsuffix("Hamburger", "hotdog")
"Hamburger"
```

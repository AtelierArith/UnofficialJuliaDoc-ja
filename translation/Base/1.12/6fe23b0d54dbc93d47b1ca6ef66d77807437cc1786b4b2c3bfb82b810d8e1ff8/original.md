```julia
ltruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…')
```

Truncate `str` to at most `maxwidth` columns (as estimated by [`textwidth`](@ref)), replacing the first characters with `replacement` if necessary. The default replacement string is "…".

# Examples

```jldoctest
julia> s = ltruncate("🍕🍕 I love 🍕", 10)
"…I love 🍕"

julia> textwidth(s)
10

julia> ltruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    This function was added in Julia 1.12.


See also [`rtruncate`](@ref) and [`ctruncate`](@ref).

```julia
rtruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…')
```

Truncate `str` to at most `maxwidth` columns (as estimated by [`textwidth`](@ref)), replacing the last characters with `replacement` if necessary. The default replacement string is "…".

# Examples

```jldoctest
julia> s = rtruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 I lo…"

julia> textwidth(s)
10

julia> rtruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    This function was added in Julia 1.12.


See also [`ltruncate`](@ref) and [`ctruncate`](@ref).

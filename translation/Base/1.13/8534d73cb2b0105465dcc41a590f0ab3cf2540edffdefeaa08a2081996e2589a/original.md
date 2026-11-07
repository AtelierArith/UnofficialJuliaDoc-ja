```julia
ctruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…'; prefer_left::Bool = true)
```

Truncate `str` to at most `maxwidth` columns (as estimated by [`textwidth`](@ref)), replacing the middle characters with `replacement` if necessary. The default replacement string is "…". By default, the truncation prefers keeping chars on the left, but this can be changed by setting `prefer_left` to `false`.

# Examples

```jldoctest
julia> s = ctruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 …e 🍕"

julia> textwidth(s)
10

julia> ctruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    This function was added in Julia 1.12.


See also [`ltruncate`](@ref) and [`rtruncate`](@ref).

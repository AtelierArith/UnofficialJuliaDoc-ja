```
lpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ') -> String
```

Stringify `s` and pad the resulting string on the left with `p` to make it `n` characters (in [`textwidth`](@ref)) long. If `s` is already `n` characters long, an equal string is returned. Pad with spaces by default.

# Examples

```jldoctest
julia> lpad("March", 10)
"     March"
```

!!! compat "Julia 1.7"
    In Julia 1.7, this function was changed to use `textwidth` rather than a raw character (codepoint) count.


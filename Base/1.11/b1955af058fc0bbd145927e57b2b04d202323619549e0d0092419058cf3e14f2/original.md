```
endswith(s::AbstractString, suffix::Union{AbstractString,Base.Chars})
```

Return `true` if `s` ends with `suffix`, which can be a string, a character, or a tuple/vector/set of characters. If `suffix` is a tuple/vector/set of characters, test whether the last character of `s` belongs to that set.

See also [`startswith`](@ref), [`contains`](@ref).

# Examples

```jldoctest
julia> endswith("Sunday", "day")
true
```

```
startswith(s::AbstractString, prefix::Union{AbstractString,Base.Chars})
```

Return `true` if `s` starts with `prefix`, which can be a string, a character, or a tuple/vector/set of characters. If `prefix` is a tuple/vector/set of characters, test whether the first character of `s` belongs to that set.

See also [`endswith`](@ref), [`contains`](@ref).

# Examples

```jldoctest
julia> startswith("JuliaLang", "Julia")
true
```

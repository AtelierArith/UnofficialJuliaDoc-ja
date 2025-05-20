```
SubString(s::AbstractString, i::Integer, j::Integer=lastindex(s))
SubString(s::AbstractString, r::UnitRange{<:Integer})
```

Like [`getindex`](@ref), but returns a view into the parent string `s` within range `i:j` or `r` respectively instead of making a copy.

The [`@views`](@ref) macro converts any string slices `s[i:j]` into substrings `SubString(s, i, j)` in a block of code.

# Examples

```jldoctest
julia> SubString("abc", 1, 2)
"ab"

julia> SubString("abc", 1:2)
"ab"

julia> SubString("abc", 2)
"bc"
```

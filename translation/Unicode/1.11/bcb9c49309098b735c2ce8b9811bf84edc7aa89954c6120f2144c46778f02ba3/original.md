```julia
isequal_normalized(s1::AbstractString, s2::AbstractString; casefold=false, stripmark=false, chartransform=identity)
```

Return whether `s1` and `s2` are canonically equivalent Unicode strings.   If `casefold=true`, ignores case (performs Unicode case-folding); if `stripmark=true`, strips diacritical marks and other combining characters.

As with [`Unicode.normalize`](@ref), you can also pass an arbitrary function via the `chartransform` keyword (mapping `Integer` codepoints to codepoints) to perform custom normalizations, such as [`Unicode.julia_chartransform`](@ref).

!!! compat "Julia 1.8"
    The `isequal_normalized` function was added in Julia 1.8.


# Examples

For example, the string `"noël"` can be constructed in two canonically equivalent ways in Unicode, depending on whether `"ë"` is formed from a single codepoint U+00EB or from the ASCII character `'e'` followed by the U+0308 combining-diaeresis character.

```jldoctest
julia> s1 = "noël"
"noël"

julia> s2 = "noël"
"noël"

julia> s1 == s2
false

julia> isequal_normalized(s1, s2)
true

julia> isequal_normalized(s1, "noel", stripmark=true)
true

julia> isequal_normalized(s1, "NOËL", casefold=true)
true
```

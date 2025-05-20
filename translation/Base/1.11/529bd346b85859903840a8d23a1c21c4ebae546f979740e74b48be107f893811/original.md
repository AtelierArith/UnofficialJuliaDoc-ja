```
==(a::AbstractString, b::AbstractString) -> Bool
```

Test whether two strings are equal character by character (technically, Unicode code point by code point). Should either string be a [`AnnotatedString`](@ref) the string properties must match too.

# Examples

```jldoctest
julia> "abc" == "abc"
true

julia> "abc" == "αβγ"
false
```

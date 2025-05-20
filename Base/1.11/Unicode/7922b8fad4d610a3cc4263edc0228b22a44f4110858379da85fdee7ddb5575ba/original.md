```
titlecase(s::AbstractString; [wordsep::Function], strict::Bool=true) -> String
```

Capitalize the first character of each word in `s`; if `strict` is true, every other character is converted to lowercase, otherwise they are left unchanged. By default, all non-letters beginning a new grapheme are considered as word separators; a predicate can be passed as the `wordsep` keyword to determine which characters should be considered as word separators. See also [`uppercasefirst`](@ref) to capitalize only the first character in `s`.

See also [`uppercase`](@ref), [`lowercase`](@ref), [`uppercasefirst`](@ref).

# Examples

```jldoctest
julia> titlecase("the JULIA programming language")
"The Julia Programming Language"

julia> titlecase("ISS - international space station", strict=false)
"ISS - International Space Station"

julia> titlecase("a-a b-b", wordsep = c->c==' ')
"A-a B-b"
```

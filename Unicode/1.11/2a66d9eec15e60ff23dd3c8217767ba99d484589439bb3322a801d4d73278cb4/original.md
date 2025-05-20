```
graphemes(s::AbstractString, m:n) -> SubString
```

Returns a [`SubString`](@ref) of `s` consisting of the `m`-th through `n`-th graphemes of the string `s`, where the second argument `m:n` is an integer-valued [`AbstractUnitRange`](@ref).

Loosely speaking, this corresponds to the `m:n`-th user-perceived "characters" in the string.  For example:

```jldoctest
julia> s = graphemes("exposé", 3:6)
"posé"

julia> collect(s)
5-element Vector{Char}:
 'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)
 'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)
 's': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)
 'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)
 '́': Unicode U+0301 (category Mn: Mark, nonspacing)
```

This consists of the 3rd to *7th* codepoints ([`Char`](@ref)s) in `"exposé"`, because the grapheme `"é"` is actually *two* Unicode codepoints (an `'e'` followed by an acute-accent combining character U+0301).

Because finding grapheme boundaries requires iteration over the string contents, the `graphemes(s, m:n)` function requires time proportional to the length of the string (number of codepoints) before the end of the substring.

!!! compat "Julia 1.9"
    The `m:n` argument of `graphemes` requires Julia 1.9.


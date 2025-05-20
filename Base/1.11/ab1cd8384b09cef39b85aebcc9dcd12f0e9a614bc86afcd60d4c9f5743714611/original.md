```
*(s::Regex, t::Union{Regex,AbstractString,AbstractChar}) -> Regex
*(s::Union{Regex,AbstractString,AbstractChar}, t::Regex) -> Regex
```

Concatenate regexes, strings and/or characters, producing a [`Regex`](@ref). String and character arguments must be matched exactly in the resulting regex, meaning that the contained characters are devoid of any special meaning (they are quoted with "\Q" and "\E").

!!! compat "Julia 1.3"
    This method requires at least Julia 1.3.


# Examples

```jldoctest
julia> match(r"Hello|Good bye" * ' ' * "world", "Hello world")
RegexMatch("Hello world")

julia> r = r"a|b" * "c|d"
r"(?:a|b)\Qc|d\E"

julia> match(r, "ac") == nothing
true

julia> match(r, "ac|d")
RegexMatch("ac|d")
```

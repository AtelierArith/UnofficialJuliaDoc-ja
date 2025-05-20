```
^(s::Regex, n::Integer) -> Regex
```

Repeat a regex `n` times.

!!! compat "Julia 1.3"
    This method requires at least Julia 1.3.


# Examples

```jldoctest
julia> r"Test "^2
r"(?:Test ){2}"

julia> match(r"Test "^2, "Test Test ")
RegexMatch("Test Test ")
```

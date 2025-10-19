```julia
strip([pred=isspace,] str::AbstractString) -> SubString
strip(str::AbstractString, chars) -> SubString
```

Remove leading and trailing characters from `str`, either those specified by `chars` or those for which the function `pred` returns `true`.

The default behaviour is to remove leading and trailing whitespace and delimiters: see [`isspace`](@ref) for precise details.

The optional `chars` argument specifies which characters to remove: it can be a single character, vector or set of characters.

See also [`lstrip`](@ref) and [`rstrip`](@ref).

!!! compat "Julia 1.2"
    The method which accepts a predicate function requires Julia 1.2 or later.


# Examples

```jldoctest
julia> strip("{3, 5}\n", ['{', '}', '\n'])
"3, 5"
```

```
rstrip([pred=isspace,] str::AbstractString) -> SubString
rstrip(str::AbstractString, chars) -> SubString
```

Remove trailing characters from `str`, either those specified by `chars` or those for which the function `pred` returns `true`.

The default behaviour is to remove trailing whitespace and delimiters: see [`isspace`](@ref) for precise details.

The optional `chars` argument specifies which characters to remove: it can be a single character, or a vector or set of characters.

See also [`strip`](@ref) and [`lstrip`](@ref).

# Examples

```jldoctest
julia> a = rpad("March", 20)
"March               "

julia> rstrip(a)
"March"
```

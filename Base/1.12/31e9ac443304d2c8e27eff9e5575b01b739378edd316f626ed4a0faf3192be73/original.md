```julia
chomp(s::AbstractString) -> SubString
```

Remove a single trailing newline from a string.

See also [`chop`](@ref).

# Examples

```jldoctest
julia> chomp("Hello\n")
"Hello"
```

```julia
chomp(s::AbstractString)::SubString
```

Remove a single trailing newline (i.e. "\r\n" or "\n") from a string.

See also [`chop`](@ref).

# Examples

```jldoctest
julia> chomp("Hello\n")
"Hello"

julia> chomp("World\r\n")
"World"

julia> chomp("Julia\r\n\n")
"Julia\r\n"
```

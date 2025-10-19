```julia
isreadonly(io) -> Bool
```

Determine whether a stream is read-only.

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> isreadonly(io)
true

julia> io = IOBuffer();

julia> isreadonly(io)
false
```

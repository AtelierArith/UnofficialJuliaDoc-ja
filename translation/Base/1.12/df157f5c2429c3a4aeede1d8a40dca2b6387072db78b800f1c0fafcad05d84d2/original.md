```julia
IOBuffer(string::String)
```

Create a read-only `IOBuffer` on the data underlying the given string.

# Examples

```jldoctest
julia> io = IOBuffer("Haho");

julia> String(take!(io))
"Haho"

julia> String(take!(io))
"Haho"
```

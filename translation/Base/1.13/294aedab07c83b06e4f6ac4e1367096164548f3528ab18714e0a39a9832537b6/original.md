```julia
IOBuffer(string::String)
```

Create a read-only `IOBuffer` on the data underlying the given string.

# Examples

```jldoctest
julia> io = IOBuffer("Haho");

julia> takestring!(io)
"Haho"

julia> takestring!(io)
"Haho"
```

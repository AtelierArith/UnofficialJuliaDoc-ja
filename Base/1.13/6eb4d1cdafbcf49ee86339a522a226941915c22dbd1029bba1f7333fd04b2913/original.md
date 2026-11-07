```julia
takestring!(io::IOBuffer)::String
```

Return the content of `io` as a `String`, resetting the buffer to its initial state. This is preferred over calling `String(take!(io))` to create a string from an `IOBuffer`.

# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, [0x61, 0x62, 0x63]);

julia> s = takestring!(io)
"abc"

julia> isempty(take!(io)) # io is now empty
true
```

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


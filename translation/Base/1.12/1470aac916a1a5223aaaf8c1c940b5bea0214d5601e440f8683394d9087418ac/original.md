```julia
bytesavailable(io)
```

Return the number of bytes available for reading before a read from this stream or buffer will block.

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> bytesavailable(io)
34
```

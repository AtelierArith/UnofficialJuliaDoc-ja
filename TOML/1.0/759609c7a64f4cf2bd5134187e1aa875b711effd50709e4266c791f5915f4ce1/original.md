```julia
tryparse(x::Union{AbstractString, IO})
tryparse(p::Parser, x::Union{AbstractString, IO})
```

Parse the string or stream `x`, and return the resulting table (dictionary). Return a [`ParserError`](@ref) upon failure.

See also [`TOML.parse`](@ref).

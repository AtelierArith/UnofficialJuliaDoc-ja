```julia
parse(x::Union{AbstractString, IO})
parse(p::Parser, x::Union{AbstractString, IO})
```

Parse the string  or stream `x`, and return the resulting table (dictionary). Throw a [`ParserError`](@ref) upon failure.

See also [`TOML.tryparse`](@ref).

```julia
parsefile(f::AbstractString)
parsefile(p::Parser, f::AbstractString)
```

Parse file `f` and return the resulting table (dictionary). Throw a [`ParserError`](@ref) upon failure.

See also [`TOML.tryparsefile`](@ref).

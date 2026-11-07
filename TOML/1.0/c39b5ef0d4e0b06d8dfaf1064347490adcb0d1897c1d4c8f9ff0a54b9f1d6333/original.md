```julia
tryparsefile(f::AbstractString)
tryparsefile(p::Parser, f::AbstractString)
```

Parse file `f` and return the resulting table (dictionary). Return a [`ParserError`](@ref) upon failure.

See also [`TOML.parsefile`](@ref).

```
pwd() -> String
```

Get the current working directory.

See also: [`cd`](@ref), [`tempdir`](@ref).

# Examples

```julia-repl
julia> pwd()
"/home/JuliaUser"

julia> cd("/home/JuliaUser/Projects/julia")

julia> pwd()
"/home/JuliaUser/Projects/julia"
```

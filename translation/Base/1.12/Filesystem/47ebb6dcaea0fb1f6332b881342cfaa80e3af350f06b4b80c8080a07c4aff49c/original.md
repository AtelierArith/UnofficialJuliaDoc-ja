```julia
basename(path::AbstractString) -> String
```

Get the file name part of a path.

!!! note
    This function differs slightly from the Unix `basename` program, where trailing slashes are ignored, i.e. `$ basename /foo/bar/` returns `bar`, whereas `basename` in Julia returns an empty string `""`.


# Examples

```jldoctest
julia> basename("/home/myuser/example.jl")
"example.jl"

julia> basename("/home/myuser/")
""
```

See also [`dirname`](@ref).

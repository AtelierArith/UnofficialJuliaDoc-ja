```
normpath(path::AbstractString) -> String
```

Normalize a path, removing "." and ".." entries and changing "/" to the canonical path separator for the system.

# Examples

```jldoctest
julia> normpath("/home/myuser/../example.jl")
"/home/example.jl"

julia> normpath("Documents/Julia") == joinpath("Documents", "Julia")
true
```

```
dirname(path::AbstractString) -> String
```

Get the directory part of a path. Trailing characters ('/' or '\') in the path are counted as part of the path.

# Examples

```jldoctest
julia> dirname("/home/myuser")
"/home"

julia> dirname("/home/myuser/")
"/home/myuser"
```

See also [`basename`](@ref).

```
isdir(path) -> Bool
```

Return `true` if `path` is a directory, `false` otherwise.

# Examples

```jldoctest
julia> isdir(homedir())
true

julia> isdir("not/a/directory")
false
```

See also [`isfile`](@ref) and [`ispath`](@ref).

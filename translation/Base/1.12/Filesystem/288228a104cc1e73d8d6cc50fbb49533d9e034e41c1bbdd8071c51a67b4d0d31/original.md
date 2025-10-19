```julia
isdir(path) -> Bool
isdir(path_elements...) -> Bool
```

Return `true` if `path` points to a directory, `false` otherwise.

# Examples

```jldoctest
julia> isdir(homedir())
true

julia> isdir("not/a/directory")
false
```

See also [`isfile`](@ref) and [`ispath`](@ref).

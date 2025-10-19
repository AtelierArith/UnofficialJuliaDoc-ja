```julia
isabspath(path::AbstractString) -> Bool
```

Determine whether a path is absolute (begins at the root directory).

# Examples

```jldoctest
julia> isabspath("/home")
true

julia> isabspath("home")
false
```

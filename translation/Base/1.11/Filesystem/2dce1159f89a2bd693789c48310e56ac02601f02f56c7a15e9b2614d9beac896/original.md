```
isdirpath(path::AbstractString) -> Bool
```

Determine whether a path refers to a directory (for example, ends with a path separator).

# Examples

```jldoctest
julia> isdirpath("/home")
false

julia> isdirpath("/home/")
true
```

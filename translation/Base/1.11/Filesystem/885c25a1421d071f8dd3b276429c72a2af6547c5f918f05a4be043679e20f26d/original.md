```
normpath(path::AbstractString, paths::AbstractString...) -> String
```

Convert a set of paths to a normalized path by joining them together and removing "." and ".." entries. Equivalent to `normpath(joinpath(path, paths...))`.

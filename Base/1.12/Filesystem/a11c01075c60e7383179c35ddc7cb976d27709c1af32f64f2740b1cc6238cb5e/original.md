```julia
issetuid(path) -> Bool
issetuid(path_elements...) -> Bool
issetuid(stat_struct) -> Bool
```

Return `true` if the file at `path` or file descriptor `stat_struct` have the setuid flag set, `false` otherwise.

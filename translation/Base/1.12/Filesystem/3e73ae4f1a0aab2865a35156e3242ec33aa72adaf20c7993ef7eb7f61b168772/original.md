```julia
issetgid(path) -> Bool
issetgid(path_elements...) -> Bool
issetgid(stat_struct) -> Bool
```

Return `true` if the file at `path` or file descriptor `stat_struct` have the setgid flag set, `false` otherwise.

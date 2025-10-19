```julia
issticky(path) -> Bool
issticky(path_elements...) -> Bool
issticky(stat_struct) -> Bool
```

Return `true` if the file at `path` or file descriptor `stat_struct` have the sticky bit set, `false` otherwise.

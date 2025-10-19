```julia
isblockdev(path) -> Bool
isblockdev(path_elements...) -> Bool
isblockdev(stat_struct) -> Bool
```

Return `true` if the path `path` or file descriptor `stat_struct` refer to a block device, `false` otherwise.

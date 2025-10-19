```julia
isfifo(path) -> Bool
isfifo(path_elements...) -> Bool
isfifo(stat_struct) -> Bool
```

Return `true` if the file at `path` or file descriptor `stat_struct` is FIFO, `false` otherwise.

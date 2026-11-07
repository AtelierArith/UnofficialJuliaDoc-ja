```julia
filemode(path)
filemode(path_elements...)
filemode(stat_struct)
```

Return the mode of the file located at `path`, or the mode indicated by the file descriptor `stat_struct`.

Equivalent to `stat(path).mode` or `stat_struct.mode`.

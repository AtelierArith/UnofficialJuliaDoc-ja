```julia
filesize(path)
filesize(path_elements...)
filesize(stat_struct)
```

Return the size of the file located at `path`, or the size indicated by file descriptor `stat_struct`.

Equivalent to `stat(path).size` or `stat_struct.size`.

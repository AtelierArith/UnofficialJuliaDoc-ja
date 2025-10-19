```julia
mtime(path)
mtime(path_elements...)
mtime(stat_struct)
```

Return the unix timestamp of when the file at `path` was last modified, or the last modified timestamp indicated by the file descriptor `stat_struct`.

Equivalent to `stat(path).mtime` or `stat_struct.mtime`.

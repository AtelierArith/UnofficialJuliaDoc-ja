```julia
ctime(path)
ctime(path_elements...)
ctime(stat_struct)
```

Return the unix timestamp of when the metadata of the file at `path` was last modified, or the last modified metadata timestamp indicated by the file descriptor `stat_struct`.

Equivalent to `stat(path).ctime` or `stat_struct.ctime`.

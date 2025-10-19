```julia
mkfifo(path::AbstractString, [mode::Integer]) -> path
```

Make a FIFO special file (a named pipe) at `path`.  Return `path` as-is on success.

`mkfifo` is supported only in Unix platforms.

!!! compat "Julia 1.11"
    `mkfifo` requires at least Julia 1.11.


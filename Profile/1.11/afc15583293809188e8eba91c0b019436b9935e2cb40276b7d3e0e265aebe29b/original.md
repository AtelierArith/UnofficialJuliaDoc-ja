```julia
fetch(;include_meta = true) -> data
```

Return a copy of the buffer of profile backtraces. Note that the values in `data` have meaning only on this machine in the current session, because it depends on the exact memory addresses used in JIT-compiling. This function is primarily for internal use; [`retrieve`](@ref) may be a better choice for most users. By default metadata such as threadid and taskid is included. Set `include_meta` to `false` to strip metadata.

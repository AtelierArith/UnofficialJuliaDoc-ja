```julia
include_dependency(path::AbstractString; track_content::Bool=true)
```

In a module, declare that the file, directory, or symbolic link specified by `path` (relative or absolute) is a dependency for precompilation; that is, if `track_content=true` the module will need to be recompiled if the content of `path` changes (if `path` is a directory the content equals `join(readdir(path))`). If `track_content=false` recompilation is triggered when the modification time `mtime` of `path` changes.

This is only needed if your module depends on a path that is not used via [`include`](@ref). It has no effect outside of compilation.

!!! compat "Julia 1.11"
    Keyword argument `track_content` requires at least Julia 1.11. An error is now thrown if `path` is not readable.


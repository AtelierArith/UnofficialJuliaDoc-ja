```
hardlink(src::AbstractString, dst::AbstractString)
```

Creates a hard link to an existing source file `src` with the name `dst`. The destination, `dst`, must not exist.

See also: [`symlink`](@ref).

!!! compat "Julia 1.8"
    This method was added in Julia 1.8.


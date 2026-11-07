```julia
edit(path::AbstractString, line::Integer=0, column::Integer=0)
```

Edit a file or directory optionally providing a line number to edit the file at. Return to the `julia` prompt when you quit the editor. The editor can be changed by setting `JULIA_EDITOR`, `VISUAL` or `EDITOR` as an environment variable.

!!! compat "Julia 1.9"
    The `column` argument requires at least Julia 1.9.


See also [`InteractiveUtils.define_editor`](@ref).

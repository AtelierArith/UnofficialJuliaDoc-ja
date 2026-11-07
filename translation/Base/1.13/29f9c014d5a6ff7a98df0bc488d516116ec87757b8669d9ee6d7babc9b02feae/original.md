```julia
redirect_stdin([stream]) -> stream
```

Like [`redirect_stdout`](@ref), but for [`stdin`](@ref). Note that the direction of the stream is reversed.

!!! note
    `stream` must be a compatible objects, such as an `IOStream`, `TTY`, [`Pipe`](@ref), socket, or `devnull`.


See also [`redirect_stdio`](@ref).

```
redirect_stdout([stream]) -> stream
```

Create a pipe to which all C and Julia level [`stdout`](@ref) output will be redirected. Return a stream representing the pipe ends. Data written to [`stdout`](@ref) may now be read from the `rd` end of the pipe.

!!! note
    `stream` must be a compatible objects, such as an `IOStream`, `TTY`, [`Pipe`](@ref), socket, or `devnull`.


See also [`redirect_stdio`](@ref).

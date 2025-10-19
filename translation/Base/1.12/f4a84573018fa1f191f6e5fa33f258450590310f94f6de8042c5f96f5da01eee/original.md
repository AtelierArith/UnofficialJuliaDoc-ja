```julia
link_pipe!(pipe; reader_supports_async=false, writer_supports_async=false)
```

Initialize `pipe` and link the `in` endpoint to the `out` endpoint. The keyword arguments `reader_supports_async`/`writer_supports_async` correspond to `OVERLAPPED` on Windows and `O_NONBLOCK` on POSIX systems. They should be `true` unless they'll be used by an external program (e.g. the output of a command executed with [`run`](@ref)).

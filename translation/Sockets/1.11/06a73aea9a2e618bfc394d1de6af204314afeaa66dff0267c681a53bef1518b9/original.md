```
listen(path::AbstractString) -> PipeServer
```

Create and listen on a named pipe / UNIX domain socket.

!!! note
    Path length on Unix is limited to somewhere between 92 and 108 bytes (cf. `man unix`).


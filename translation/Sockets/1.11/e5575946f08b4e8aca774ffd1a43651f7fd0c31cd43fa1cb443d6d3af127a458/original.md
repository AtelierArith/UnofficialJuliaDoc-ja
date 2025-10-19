```julia
connect(path::AbstractString) -> PipeEndpoint
```

Connect to the named pipe / UNIX domain socket at `path`.

!!! note
    Path length on Unix is limited to somewhere between 92 and 108 bytes (cf. `man unix`).


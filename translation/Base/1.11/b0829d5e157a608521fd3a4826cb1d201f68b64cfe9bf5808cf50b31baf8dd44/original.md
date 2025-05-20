```
closewrite(stream)
```

Shutdown the write half of a full-duplex I/O stream. Performs a [`flush`](@ref) first. Notify the other end that no more data will be written to the underlying file. This is not supported by all IO types.

If implemented, `closewrite` causes subsequent `read` or `eof` calls that would block to instead throw EOF or return true, respectively. If the stream is already closed, this is idempotent.

# Examples

```jldoctest
julia> io = Base.BufferStream(); # this never blocks, so we can read and write on the same Task

julia> write(io, "request");

julia> # calling `read(io)` here would block forever

julia> closewrite(io);

julia> read(io, String)
"request"
```

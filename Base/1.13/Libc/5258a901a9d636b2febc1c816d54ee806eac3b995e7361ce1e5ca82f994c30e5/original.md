```julia
RawFD
```

Primitive type which wraps the native OS file descriptor. `RawFD`s can be passed to methods like [`stat`](@ref) to discover information about the underlying file, and can also be used to open streams, with the `RawFD` describing the OS file backing the stream.

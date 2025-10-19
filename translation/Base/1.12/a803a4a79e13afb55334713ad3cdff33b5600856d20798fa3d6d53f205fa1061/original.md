```julia
IOContext
```

`IOContext` provides a mechanism for passing output configuration settings among [`show`](@ref) methods.

In short, it is an immutable dictionary that is a subclass of `IO`. It supports standard dictionary operations such as [`getindex`](@ref), and can also be used as an I/O stream.

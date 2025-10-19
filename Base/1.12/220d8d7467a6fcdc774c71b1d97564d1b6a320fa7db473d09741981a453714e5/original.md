```julia
fd(x) -> RawFD
```

Return the file descriptor backing the stream, file, or socket.

`RawFD` objects can be passed directly to other languages via the `ccall` interface.

!!! compat "Julia 1.12"
    Prior to 1.12, this function returned an `Int` instead of a `RawFD`. You may use `RawFD(fd(x))` to produce a `RawFD` in all Julia versions.


!!! compat "Julia 1.12"
    Getting the file descriptor of sockets are supported as of Julia 1.12.


!!! warning
    Duplicate the returned file descriptor with [`Libc.dup()`](@ref) before passing it to another system that will take ownership of it (e.g. a C library). Otherwise both the Julia object `x` and the other system may try to close the file descriptor, which will cause errors.


!!! warning
    The file descriptors for sockets are asynchronous (i.e. `O_NONBLOCK` on POSIX and `OVERLAPPED` on Windows), they may behave differently than regular file descriptors.


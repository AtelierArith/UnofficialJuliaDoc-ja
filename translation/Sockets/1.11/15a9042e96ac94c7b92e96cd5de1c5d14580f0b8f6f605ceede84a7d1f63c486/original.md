```julia
TCPSocket(; delay=true)
```

Open a TCP socket using libuv. If `delay` is true, libuv delays creation of the socket's file descriptor till the first [`bind`](@ref) call. `TCPSocket` has various fields to denote the state of the socket as well as its send/receive buffers.

```
nagle(socket::Union{TCPServer, TCPSocket}, enable::Bool)
```

Nagle's algorithm batches multiple small TCP packets into larger ones. This can improve throughput but worsen latency. Nagle's algorithm is enabled by default. This function sets whether Nagle's algorithm is active on a given TCP server or socket. The opposite option is called `TCP_NODELAY` in other languages.

!!! compat "Julia 1.3"
    This function requires Julia 1.3 or later.


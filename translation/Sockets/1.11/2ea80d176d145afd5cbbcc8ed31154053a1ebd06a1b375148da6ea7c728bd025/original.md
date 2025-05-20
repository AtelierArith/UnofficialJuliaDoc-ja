```
InetAddr(str::AbstractString, port) -> InetAddr
```

Return an `InetAddr` object from ip address `str` formatted as [`AbstractString`](@ref) and port number `port`.

!!! compat "Julia 1.3"
    This constructor requires at least Julia 1.3.


# Examples

```jldoctest
julia> Sockets.InetAddr("127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

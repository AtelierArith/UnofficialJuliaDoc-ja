```
InetAddr(ip::IPAddr, port) -> InetAddr
```

Return an `InetAddr` object from ip address `ip` and port number `port`.

# Examples

```jldoctest
julia> Sockets.InetAddr(ip"127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

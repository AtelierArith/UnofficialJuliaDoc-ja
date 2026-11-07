```julia
InetAddr(ip::IPAddr, port) -> InetAddr
```

IPアドレス`ip`、ポート番号`port`からオブジェクトを返します（`InetAddr`）。

# Examples

```jldoctest
julia> Sockets.InetAddr(ip"127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

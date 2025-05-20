```
InetAddr(ip::IPAddr, port) -> InetAddr
```

IPアドレス`ip`とポート番号`port`から`InetAddr`オブジェクトを返します。

# 例

```jldoctest
julia> Sockets.InetAddr(ip"127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

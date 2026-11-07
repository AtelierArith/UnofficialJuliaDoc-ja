```julia
getsockname(sock::Union{TCPServer, TCPSocket}) -> (IPAddr, UInt16)
```

指定したソケットがバインドされている IP アドレスとポートを取得します。

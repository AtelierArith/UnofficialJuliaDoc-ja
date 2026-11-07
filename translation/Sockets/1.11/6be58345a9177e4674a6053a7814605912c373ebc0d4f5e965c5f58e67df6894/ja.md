```julia
quickack(socket::Union{TCPServer, TCPSocket}, enable::Bool)
```

Linux システムでは、`socket` で TCP_QUICKACK が無効または有効になります。

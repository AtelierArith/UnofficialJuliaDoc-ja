```julia
quickack(socket::Union{TCPServer, TCPSocket}, enable::Bool)
```

Linuxシステムでは、`socket`でTCP_QUICKACKが無効または有効になります。

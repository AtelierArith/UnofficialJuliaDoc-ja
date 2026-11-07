```julia
recvfrom(socket::UDPSocket) -> (host_port, data)
```

指定したソケットから UDP パケットを読み取り、`(host_port, data)` のタプルを返します。このとき、`host_port` は、適切な型の InetAddr{IPv4} または InetAddr{IPv6} になります。

!!! compat "Julia 1.3"
    Julia 1.3 より前のバージョンでは、最初に返される値はアドレス（`IPAddr`）でした。バージョン 1.3 で `InetAddr` に変更されました。


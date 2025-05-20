```
recvfrom(socket::UDPSocket) -> (host_port, data)
```

指定されたソケットからUDPパケットを読み取り、`(host_port, data)`のタプルを返します。ここで、`host_port`は適切に`InetAddr{IPv4}`または`InetAddr{IPv6}`になります。

!!! compat "Julia 1.3"
    Juliaバージョン1.3以前では、最初に返される値はアドレス（`IPAddr`）でした。バージョン1.3では`InetAddr`に変更されました。


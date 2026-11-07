```julia
getpeername(sock::TCPSocket) -> (IPAddr, UInt16)
```

指定したソケットが接続しているリモートエンドポイントの IP アドレスとポートを取得します。接続済みの TCP ソケットでのみ有効です。

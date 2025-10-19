```julia
leave_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

特定のマルチキャストグループを `group_addr` で定義されたソケットから削除します。 `interface_addr` が指定されている場合、マルチホーミングシステムの特定のインターフェースを指定します。 グループの受信を有効にするには `join_multicast_group()` を使用してください。

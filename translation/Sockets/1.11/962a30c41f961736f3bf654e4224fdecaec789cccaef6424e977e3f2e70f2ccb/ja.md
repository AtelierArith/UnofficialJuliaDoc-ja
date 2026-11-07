```julia
leave_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

`group_addr`で定義された特定のマルチキャストグループからソケットを削除します。`interface_addr`を指定すると、複数のネットワークインターフェースを持つシステムで特定のインターフェースを指定できます。グループの受信を有効にするには、`join_multicast_group()`を使用します。

```julia
join_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

ソケットを、`group_addr`で定義された特定のマルチキャストグループに参加させます。`interface_addr`を指定すると、複数のネットワークインターフェースを持つシステムで、特定のインターフェースを指定できます。グループからの受信を無効にするには、`leave_multicast_group()`を使用します。

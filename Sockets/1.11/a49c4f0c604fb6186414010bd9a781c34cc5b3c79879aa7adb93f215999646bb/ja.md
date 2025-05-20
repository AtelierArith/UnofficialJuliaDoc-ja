```
leave_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

特定のマルチキャストグループからソケットを削除します。`group_addr`で定義されます。`interface_addr`が指定されている場合、マルチホーミングシステムの特定のインターフェースを指定します。グループの受信を有効にするには、`join_multicast_group()`を使用してください。

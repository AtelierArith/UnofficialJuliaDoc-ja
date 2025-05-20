```
join_multicast_group(sock::UDPSocket, group_addr, interface_addr = nothing)
```

特定のマルチキャストグループにソケットを参加させます。これは `group_addr` によって定義されます。`interface_addr` が指定されている場合、マルチホーミングシステムの特定のインターフェースを指定します。グループの受信を無効にするには `leave_multicast_group()` を使用してください。

```julia
ssh_tunnel(user, host, bind_addr, port, sshflags, multiplex) -> localport
```

リモートワーカーへの SSH トンネルを確立します。`localhost:localport` が `host:port` に接続できるよう、ポート番号 `localport` を返します。

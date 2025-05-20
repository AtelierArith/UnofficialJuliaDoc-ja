```
ssh_tunnel(user, host, bind_addr, port, sshflags, multiplex) -> localport
```

リモートワーカーへのSSHトンネルを確立します。`localhost:localport`が`host:port`に接続するように、ポート番号`localport`を返します。

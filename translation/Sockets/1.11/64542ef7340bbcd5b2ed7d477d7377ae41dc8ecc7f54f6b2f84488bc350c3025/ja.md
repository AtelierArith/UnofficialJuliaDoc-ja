```julia
bind(socket::Union{TCPServer, UDPSocket, TCPSocket}, host::IPAddr, port::Integer; ipv6only=false, reuseaddr=false, kws...)
```

`socket`を指定された`host:port`にバインドします。`0.0.0.0`はすべてのデバイスでリッスンします。

  * `ipv6only`パラメータはデュアルスタックモードを無効にします。`ipv6only=true`の場合、IPv6スタックのみが作成されます。
  * `reuseaddr=true`の場合、複数のスレッドまたはプロセスが同じアドレスにバインドできますが、すべてが`reuseaddr=true`を設定している必要があります。ただし、最後にバインドしたものだけがトラフィックを受信します。

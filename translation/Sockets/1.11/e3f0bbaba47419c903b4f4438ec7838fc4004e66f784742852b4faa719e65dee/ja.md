```julia
bind(socket::Union{TCPServer, UDPSocket, TCPSocket}, host::IPAddr, port::Integer; ipv6only=false, reuseaddr=false, kws...)
```

`socket`を指定された`host:port`にバインドします。`0.0.0.0`はすべてのデバイスで待ち受けることに注意してください。

  * `ipv6only`パラメーターを指定すると、デュアルスタックモードが無効になります。`ipv6only=true`の場合、IPv6スタックのみが作成されます。
  * `reuseaddr=true`の場合、複数のスレッドまたはプロセスが`reuseaddr=true`を設定すれば、同じアドレスにエラーなくバインドできます。ただし、トラフィックを受信できるのは最後にバインドしたものだけです。

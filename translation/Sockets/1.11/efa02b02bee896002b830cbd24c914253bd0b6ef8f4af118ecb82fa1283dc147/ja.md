```julia
send(socket::UDPSocket, host::IPAddr, port::Integer, msg)
```

`msg`を`socket`経由で`host:port`に送信します。

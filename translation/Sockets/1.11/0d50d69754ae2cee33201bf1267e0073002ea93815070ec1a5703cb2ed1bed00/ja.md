```julia
send(socket::UDPSocket, host::IPAddr, port::Integer, msg)
```

`msg`を`socket`を介して`host:port`に送信します。

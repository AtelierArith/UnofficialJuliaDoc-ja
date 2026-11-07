```julia
getaddrinfo(host::AbstractString) -> IPAddr
```

`host`の最初に利用可能なIPアドレスを取得します。これは`IPv4`または`IPv6`アドレスのいずれかです。オペレーティングシステムの基盤となるgetaddrinfo実装を使用するため、DNSルックアップが行われる場合があります。

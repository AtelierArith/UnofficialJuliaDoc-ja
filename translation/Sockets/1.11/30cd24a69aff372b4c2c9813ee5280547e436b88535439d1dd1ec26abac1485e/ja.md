```julia
getaddrinfo(host::AbstractString) -> IPAddr
```

`host` の最初に利用可能な IP アドレスを取得します。これは `IPv4` アドレスまたは `IPv6` アドレスのいずれかです。オペレーティングシステムの基盤となる getaddrinfo 実装を使用するため、DNS ルックアップが行われる場合があります。

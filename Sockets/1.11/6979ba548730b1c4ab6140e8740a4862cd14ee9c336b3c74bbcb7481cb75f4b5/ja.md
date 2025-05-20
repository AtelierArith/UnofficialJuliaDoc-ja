```
getaddrinfo(host::AbstractString) -> IPAddr
```

`host`の最初の利用可能なIPアドレスを取得します。これは`IPv4`または`IPv6`アドレスのいずれかである可能性があります。オペレーティングシステムの基盤となるgetaddrinfo実装を使用し、DNSルックアップを行う場合があります。

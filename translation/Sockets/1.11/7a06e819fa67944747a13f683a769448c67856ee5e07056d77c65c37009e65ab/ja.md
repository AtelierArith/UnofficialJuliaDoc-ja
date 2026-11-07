```julia
getnameinfo(host::IPAddr) -> String
```

オペレーティングシステムの基盤となる`getnameinfo`実装を使用して、IPアドレスの逆引きを行い、ホスト名とサービスを返します。

# Examples

```julia-repl
julia> getnameinfo(IPv4("8.8.8.8"))
"google-public-dns-a.google.com"
```

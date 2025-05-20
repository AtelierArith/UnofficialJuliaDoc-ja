```
getnameinfo(host::IPAddr) -> String
```

IPアドレスの逆引きを行い、オペレーティングシステムの基盤となる `getnameinfo` 実装を使用してホスト名とサービスを返します。

# 例

```julia-repl
julia> getnameinfo(IPv4("8.8.8.8"))
"google-public-dns-a.google.com"
```

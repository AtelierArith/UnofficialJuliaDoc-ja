```julia
getaddrinfo(host::AbstractString, IPAddr) -> IPAddr
```

指定された `IPAddr` タイプの `host` の最初の IP アドレスを取得します。オペレーティングシステムの基盤となる getaddrinfo 実装を使用し、DNS ルックアップを行う場合があります。

# 例

```julia-repl
julia> getaddrinfo("localhost", IPv6)
ip"::1"

julia> getaddrinfo("localhost", IPv4)
ip"127.0.0.1"
```

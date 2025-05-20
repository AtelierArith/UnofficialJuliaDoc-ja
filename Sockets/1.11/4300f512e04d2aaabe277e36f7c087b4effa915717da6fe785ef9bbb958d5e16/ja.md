```
getalladdrinfo(host::AbstractString) -> Vector{IPAddr}
```

`host`のすべてのIPアドレスを取得します。オペレーティングシステムの基盤となる`getaddrinfo`実装を使用し、DNSルックアップを行う場合があります。

# 例

```julia-repl
julia> getalladdrinfo("google.com")
2-element Array{IPAddr,1}:
 ip"172.217.6.174"
 ip"2607:f8b0:4000:804::200e"
```

```julia
getalladdrinfo(host::AbstractString) -> Vector{IPAddr}
```

`host` のすべての IP アドレスを取得します。オペレーティングシステムの基盤となる `getaddrinfo` 実装を使用します。この実装では、DNS ルックアップが行われる場合があります。

# Examples

```julia-repl
julia> getalladdrinfo("google.com")
2-element Vector{IPAddr}:
 ip"172.217.6.174"
 ip"2607:f8b0:4000:804::200e"
```

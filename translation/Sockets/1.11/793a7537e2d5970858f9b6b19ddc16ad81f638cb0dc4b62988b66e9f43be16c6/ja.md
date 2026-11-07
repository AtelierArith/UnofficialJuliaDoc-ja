```julia
getaddrinfo(host::AbstractString, IPAddr) -> IPAddr
```

指定された`host`の`IPAddr`型の最初のIPアドレスを取得します。オペレーティングシステムの基盤となるgetaddrinfo実装を使用するため、DNSルックアップが行われる場合があります。

# Examples

```jldoctest; filter = r"(ip\"::1\"|ERROR: DNSError:.*|Stacktrace:(\n \[0-9]+\].*)*)"
julia> getaddrinfo("localhost", IPv6)
ip"::1"

julia> getaddrinfo("localhost", IPv4)
ip"127.0.0.1"
```

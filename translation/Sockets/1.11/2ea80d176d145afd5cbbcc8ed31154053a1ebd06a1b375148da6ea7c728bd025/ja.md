```
InetAddr(str::AbstractString, port) -> InetAddr
```

IPアドレス`str`を[`AbstractString`](@ref)としてフォーマットし、ポート番号`port`から`InetAddr`オブジェクトを返します。

!!! compat "Julia 1.3"
    このコンストラクタは少なくともJulia 1.3が必要です。


# 例

```jldoctest
julia> Sockets.InetAddr("127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

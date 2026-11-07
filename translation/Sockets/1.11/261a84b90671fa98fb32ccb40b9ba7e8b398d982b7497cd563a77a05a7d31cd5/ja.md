```julia
InetAddr(str::AbstractString, port) -> InetAddr
```

IPアドレス`str`とポート番号`port`から、[`AbstractString`](@ref)形式の`InetAddr`オブジェクトを返します。

!!! compat "Julia 1.3"
    このコンストラクターを使用するには、Julia 1.3以降が必要です。


# Examples

```jldoctest
julia> Sockets.InetAddr("127.0.0.1", 8000)
Sockets.InetAddr{IPv4}(ip"127.0.0.1", 8000)
```

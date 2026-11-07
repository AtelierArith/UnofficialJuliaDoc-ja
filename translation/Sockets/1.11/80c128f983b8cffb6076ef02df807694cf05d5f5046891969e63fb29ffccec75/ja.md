```julia
getipaddrs(addr_type::Type{T}=IPAddr; loopback::Bool=false) where T<:IPAddr -> Vector{T}
```

ローカルマシンの IP アドレスを取得します。

省略可能な `addr_type` パラメーターに `IPv4` または `IPv6` を指定すると、その種類のアドレスのみが返されます。

`loopback` キーワード引数は、ループバックアドレス（例: `ip"127.0.0.1"`、`ip"::1"`）を含めるかどうかを指定します。

!!! compat "Julia 1.2"
    この関数は Julia 1.2 以降で利用できます。


# Examples

```julia-repl
julia> getipaddrs()
5-element Vector{IPAddr}:
 ip"198.51.100.17"
 ip"203.0.113.2"
 ip"2001:db8:8:4:445e:5fff:fe5d:5500"
 ip"2001:db8:8:4:c164:402e:7e3c:3668"
 ip"fe80::445e:5fff:fe5d:5500"

julia> getipaddrs(IPv6)
3-element Vector{IPv6}:
 ip"2001:db8:8:4:445e:5fff:fe5d:5500"
 ip"2001:db8:8:4:c164:402e:7e3c:3668"
 ip"fe80::445e:5fff:fe5d:5500"
```

こちらも参照: [`islinklocaladdr`](@ref)。

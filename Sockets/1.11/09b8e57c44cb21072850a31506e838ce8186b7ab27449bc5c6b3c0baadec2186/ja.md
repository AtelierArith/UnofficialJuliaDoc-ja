```julia
getipaddrs(addr_type::Type{T}=IPAddr; loopback::Bool=false) where T<:IPAddr -> Vector{T}
```

ローカルマシンのIPアドレスを取得します。

オプションの`addr_type`パラメータを`IPv4`または`IPv6`に設定すると、そのタイプのアドレスのみが返されます。

`loopback`キーワード引数は、ループバックアドレス（例：`ip"127.0.0.1"`、`ip"::1"`）が含まれるかどうかを決定します。

!!! compat "Julia 1.2"
    この関数はJulia 1.2以降で利用可能です。


# 例

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

関連情報は[`islinklocaladdr`](@ref)を参照してください。

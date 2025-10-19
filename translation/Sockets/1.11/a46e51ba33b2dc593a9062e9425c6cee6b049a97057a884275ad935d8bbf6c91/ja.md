```julia
getipaddr() -> IPAddr
```

ローカルマシンのIPアドレスを取得し、IPv4をIPv6よりも優先します。利用可能なアドレスがない場合は例外をスローします。

```julia
getipaddr(addr_type::Type{T}) where T<:IPAddr -> T
```

指定されたタイプのローカルマシンのIPアドレスを取得します。指定されたタイプのアドレスが利用できない場合は例外をスローします。

この関数は[`getipaddrs`](@ref)の後方互換性ラッパーです。新しいアプリケーションは代わりに[`getipaddrs`](@ref)を使用するべきです。

# 例

```julia-repl
julia> getipaddr()
ip"192.168.1.28"

julia> getipaddr(IPv6)
ip"fe80::9731:35af:e1c5:6e49"
```

さらに[`getipaddrs`](@ref)も参照してください。

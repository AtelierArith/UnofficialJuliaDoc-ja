```julia
getipaddr() -> IPAddr
```

ローカルマシンの IP アドレスを取得します。IPv4 アドレスが IPv6 アドレスより優先されます。アドレスがない場合は例外をスローします。

```julia
getipaddr(addr_type::Type{T}) where T<:IPAddr -> T
```

指定した種類のローカルマシンの IP アドレスを取得します。指定した種類のアドレスがない場合は例外をスローします。

この関数は、後方互換性のための [`getipaddrs`](@ref) のラッパーです。新しいアプリケーションでは、代わりに [`getipaddrs`](@ref) を使用してください。

# Examples

```julia-repl
julia> getipaddr()
ip"192.168.1.28"

julia> getipaddr(IPv6)
ip"fe80::9731:35af:e1c5:6e49"
```

[`getipaddrs`](@ref) も参照してください。

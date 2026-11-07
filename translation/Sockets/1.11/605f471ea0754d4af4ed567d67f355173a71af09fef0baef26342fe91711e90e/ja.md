```julia
IPv4(host::Integer) -> IPv4
```

IPアドレス `host` を [`Integer`](@ref) としてフォーマットした IPv4 オブジェクトを返します。

# Examples

```jldoctest
julia> IPv4(3223256218)
ip"192.30.252.154"
```

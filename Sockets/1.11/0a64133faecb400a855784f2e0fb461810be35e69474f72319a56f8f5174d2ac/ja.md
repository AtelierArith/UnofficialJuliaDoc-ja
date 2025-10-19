```julia
IPv4(host::Integer) -> IPv4
```

IPアドレス`host`を[`Integer`](@ref)としてフォーマットされたIPv4オブジェクトを返します。

# 例

```jldoctest
julia> IPv4(3223256218)
ip"192.30.252.154"
```

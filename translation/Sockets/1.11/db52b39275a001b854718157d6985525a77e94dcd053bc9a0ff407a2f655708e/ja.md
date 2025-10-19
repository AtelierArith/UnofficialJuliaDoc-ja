```julia
IPv6(host::Integer) -> IPv6
```

IPアドレス`host`を[`Integer`](@ref)としてフォーマットされたIPv6オブジェクトを返します。

# 例

```jldoctest
julia> IPv6(3223256218)
ip"::c01e:fc9a"
```

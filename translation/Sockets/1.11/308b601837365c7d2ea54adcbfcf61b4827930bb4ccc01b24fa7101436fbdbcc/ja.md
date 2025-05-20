```
IPv4(host::Integer) -> IPv4
```

IPアドレス `host` を [`Integer`](@ref) 形式で指定して、IPv4オブジェクトを返します。

# 例

```jldoctest
julia> IPv4(3223256218)
ip"192.30.252.154"
```

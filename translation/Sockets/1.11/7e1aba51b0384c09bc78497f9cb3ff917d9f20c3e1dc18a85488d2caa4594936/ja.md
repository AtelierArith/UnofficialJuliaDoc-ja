```julia
IPv6(host::Integer) -> IPv6
```

IPアドレス `host` から、[`Integer`](@ref) としてフォーマットされた IPv6 オブジェクトを返します。

# Examples

```jldoctest
julia> IPv6(3223256218)
ip"::c01e:fc9a"
```

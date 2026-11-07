```julia
IPv6(str::AbstractString) -> IPv6
```

IPv6アドレス文字列を`IPv6`オブジェクトに解析します。

# Examples

```jldoctest
julia> IPv6("::1")
ip"::1"
```

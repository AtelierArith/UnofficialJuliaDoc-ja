```julia
IPv6(str::AbstractString) -> IPv6
```

Parse an IPv6 address string into an `IPv6` object.

# Examples

```jldoctest
julia> IPv6("::1")
ip"::1"
```

```julia
uuid_version(u::UUID)::Int
```

指定されたUUIDを調べ、そのバージョンを返します（[RFC 4122](https://tools.ietf.org/html/rfc4122)を参照）。

# Examples

```jldoctest
julia> uuid_version(uuid4())
4
```

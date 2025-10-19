```julia
uuid_version(u::UUID) -> Int
```

与えられたUUIDを検査し、そのバージョンを返します（[RFC 4122](https://tools.ietf.org/html/rfc4122)を参照）。

# 例

```jldoctest
julia> uuid_version(uuid4())
4
```

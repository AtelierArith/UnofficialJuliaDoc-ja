```
uuid_version(u::UUID) -> Int
```

Inspects the given UUID and returns its version (see [RFC 4122](https://www.ietf.org/rfc/rfc4122)).

# Examples

```jldoctest
julia> uuid_version(uuid4())
4
```

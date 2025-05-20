```
leading_ones(x::Integer) -> Integer
```

Number of ones leading the binary representation of `x`.

# Examples

```jldoctest
julia> leading_ones(UInt32(2 ^ 32 - 2))
31
```

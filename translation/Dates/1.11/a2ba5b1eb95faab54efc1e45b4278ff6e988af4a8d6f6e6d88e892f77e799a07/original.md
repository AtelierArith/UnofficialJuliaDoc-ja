```
now(::Type{UTC}) -> DateTime
```

Return a `DateTime` corresponding to the user's system time as UTC/GMT. For other time zones, see the TimeZones.jl package.

# Examples

```julia
julia> now(UTC)
2023-01-04T10:52:24.864
```

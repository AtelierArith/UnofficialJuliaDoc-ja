```julia
now(::Type{UTC})::DateTime
```

Return a `DateTime` corresponding to the user's system time as UTC/GMT. For other time zones, see the TimeZones.jl package.

# Examples

```jldoctest; filter = r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?" => "2023-01-04T10:52:24.864"
julia> now(UTC)
2023-01-04T10:52:24.864
```

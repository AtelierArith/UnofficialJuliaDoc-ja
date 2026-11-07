```julia
Dates.ISOTimeFormat
```

Describes the ISO8601 formatting for a time. This is the default value for `Dates.format` of a `Time`.

# Examples

```jldoctest
julia> Dates.format(Time(12, 0, 43, 1), ISOTimeFormat)
"12:00:43.001"
```

```julia
Dates.ISODateTimeFormat
```

Describes the ISO8601 formatting for a date and time. This is the default value for `Dates.format` of a `DateTime`.

# Examples

```jldoctest
julia> Dates.format(DateTime(2018, 8, 8, 12, 0, 43, 1), ISODateTimeFormat)
"2018-08-08T12:00:43.001"
```

```julia
Dates.ISODateFormat
```

Describes the ISO8601 formatting for a date. This is the default value for `Dates.format` of a `Date`.

# Examples

```jldoctest
julia> Dates.format(Date(2018, 8, 8), ISODateFormat)
"2018-08-08"
```

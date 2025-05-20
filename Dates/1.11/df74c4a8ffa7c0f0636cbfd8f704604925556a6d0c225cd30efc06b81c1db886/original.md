```
Dates.RFC1123Format
```

Describes the RFC1123 formatting for a date and time.

# Examples

```jldoctest
julia> Dates.format(DateTime(2018, 8, 8, 12, 0, 43, 1), RFC1123Format)
"Wed, 08 Aug 2018 12:00:43"
```

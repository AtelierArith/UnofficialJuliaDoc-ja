```julia
lastdayofweek(dt::TimeType) -> TimeType
```

Adjusts `dt` to the Sunday of its week.

# Examples

```jldoctest
julia> lastdayofweek(DateTime("1996-01-05T12:30:00"))
1996-01-07T00:00:00
```

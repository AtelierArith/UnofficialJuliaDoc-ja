```julia
lastdayofmonth(dt::TimeType) -> TimeType
```

Adjusts `dt` to the last day of its month.

# Examples

```jldoctest
julia> lastdayofmonth(DateTime("1996-05-20"))
1996-05-31T00:00:00
```

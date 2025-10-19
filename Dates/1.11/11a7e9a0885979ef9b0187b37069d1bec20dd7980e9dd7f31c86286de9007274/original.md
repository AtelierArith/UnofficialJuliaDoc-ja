```julia
firstdayofmonth(dt::TimeType) -> TimeType
```

Adjusts `dt` to the first day of its month.

# Examples

```jldoctest
julia> firstdayofmonth(DateTime("1996-05-20"))
1996-05-01T00:00:00
```

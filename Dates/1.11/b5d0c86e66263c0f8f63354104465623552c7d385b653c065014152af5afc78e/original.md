```julia
lastdayofyear(dt::TimeType) -> TimeType
```

Adjusts `dt` to the last day of its year.

# Examples

```jldoctest
julia> lastdayofyear(DateTime("1996-05-20"))
1996-12-31T00:00:00
```

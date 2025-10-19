```julia
daysinyear(dt::TimeType) -> Int
```

Return 366 if the year of `dt` is a leap year, otherwise return 365.

# Examples

```jldoctest
julia> daysinyear(1999)
365

julia> daysinyear(2000)
366
```

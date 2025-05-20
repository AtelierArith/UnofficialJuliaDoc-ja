```
Dates
```

The `Dates` module provides `Date`, `DateTime`, `Time` types, and related functions.

The types are not aware of time zones, based on UT seconds (86400 seconds a day, avoiding leap seconds), and use the proleptic Gregorian calendar, as specified in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601). For time zone functionality, see the TimeZones.jl package.

```jldoctest
julia> dt = DateTime(2017,12,31,23,59,59,999)
2017-12-31T23:59:59.999

julia> d1 = Date(Month(12), Year(2017))
2017-12-01

julia> d2 = Date("2017-12-31", DateFormat("y-m-d"))
2017-12-31

julia> yearmonthday(d2)
(2017, 12, 31)

julia> d2-d1
30 days
```

Please see the manual section on [`Date`](@ref) and [`DateTime`](@ref) for more information.

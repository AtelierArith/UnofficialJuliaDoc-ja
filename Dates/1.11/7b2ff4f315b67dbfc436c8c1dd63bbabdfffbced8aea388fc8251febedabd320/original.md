```
week(dt::TimeType) -> Int64
```

Return the [ISO week date](https://en.wikipedia.org/wiki/ISO_week_date) of a `Date` or `DateTime` as an [`Int64`](@ref). Note that the first week of a year is the week that contains the first Thursday of the year, which can result in dates prior to January 4th being in the last week of the previous year. For example, `week(Date(2005, 1, 1))` is the 53rd week of 2004.

# Examples

```jldoctest
julia> week(Date(1989, 6, 22))
25

julia> week(Date(2005, 1, 1))
53

julia> week(Date(2004, 12, 31))
53
```

```
monthname(dt::TimeType; locale="english") -> String
monthname(month::Integer, locale="english") -> String
```

Return the full name of the month of the `Date` or `DateTime` or `Integer` in the given `locale`.

# Examples

```jldoctest
julia> monthname(Date("2005-01-04"))
"January"

julia> monthname(2)
"February"
```

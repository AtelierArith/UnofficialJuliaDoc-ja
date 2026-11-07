```julia
monthname(dt::TimeType; locale="english")::String
monthname(month::Integer, locale="english")::String
```

指定された`locale`の中から、`Date`、`DateTime`、または`Integer`の月の正式名称を返してください。

# Examples

```jldoctest
julia> monthname(Date("2005-01-04"))
"January"

julia> monthname(2)
"February"
```

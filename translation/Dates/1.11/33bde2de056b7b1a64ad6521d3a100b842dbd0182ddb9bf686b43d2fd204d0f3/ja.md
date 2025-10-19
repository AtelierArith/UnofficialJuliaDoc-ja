```julia
lastdayofweek(dt::TimeType) -> TimeType
```

`dt`をその週の日曜日に調整します。

# 例

```jldoctest
julia> lastdayofweek(DateTime("1996-01-05T12:30:00"))
1996-01-07T00:00:00
```

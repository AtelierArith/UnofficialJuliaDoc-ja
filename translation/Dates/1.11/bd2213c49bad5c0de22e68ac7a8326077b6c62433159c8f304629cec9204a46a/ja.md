```julia
firstdayofweek(dt::TimeType) -> TimeType
```

`dt`をその週の月曜日に調整します。

# 例

```jldoctest
julia> firstdayofweek(DateTime("1996-01-05T12:30:00"))
1996-01-01T00:00:00
```

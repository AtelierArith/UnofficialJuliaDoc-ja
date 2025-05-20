```
lastdayofmonth(dt::TimeType) -> TimeType
```

`dt`をその月の最終日に調整します。

# 例

```jldoctest
julia> lastdayofmonth(DateTime("1996-05-20"))
1996-05-31T00:00:00
```

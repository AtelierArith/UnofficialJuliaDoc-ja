```
firstdayofmonth(dt::TimeType) -> TimeType
```

`dt`をその月の初日に調整します。

# 例

```jldoctest
julia> firstdayofmonth(DateTime("1996-05-20"))
1996-05-01T00:00:00
```

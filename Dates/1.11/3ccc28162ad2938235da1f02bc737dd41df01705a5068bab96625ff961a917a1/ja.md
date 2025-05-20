```
firstdayofyear(dt::TimeType) -> TimeType
```

`dt`をその年の最初の日に調整します。

# 例

```jldoctest
julia> firstdayofyear(DateTime("1996-05-20"))
1996-01-01T00:00:00
```

```
lastdayofquarter(dt::TimeType) -> TimeType
```

`dt`をその四半期の最終日に調整します。

# 例

```jldoctest
julia> lastdayofquarter(DateTime("1996-05-20"))
1996-06-30T00:00:00

julia> lastdayofquarter(DateTime("1996-08-20"))
1996-09-30T00:00:00
```

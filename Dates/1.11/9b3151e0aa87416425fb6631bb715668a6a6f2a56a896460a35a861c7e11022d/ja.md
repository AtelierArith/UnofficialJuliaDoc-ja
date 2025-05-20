```
trunc(dt::TimeType, ::Type{Period}) -> TimeType
```

指定された`Period`型に従って`dt`の値を切り捨てます。

# 例

```jldoctest
julia> trunc(DateTime("1996-01-01T12:30:00"), Day)
1996-01-01T00:00:00
```

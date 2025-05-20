```
CompoundPeriod(periods) -> CompoundPeriod
```

`Period`の`Vector`から`CompoundPeriod`を構築します。同じタイプのすべての`Period`は一緒に加算されます。

# 例

```jldoctest
julia> Dates.CompoundPeriod(Dates.Hour(12), Dates.Hour(13))
25 hours

julia> Dates.CompoundPeriod(Dates.Hour(-1), Dates.Minute(1))
-1 hour, 1 minute

julia> Dates.CompoundPeriod(Dates.Month(1), Dates.Week(-2))
1 month, -2 weeks

julia> Dates.CompoundPeriod(Dates.Minute(50000))
50000 minutes
```

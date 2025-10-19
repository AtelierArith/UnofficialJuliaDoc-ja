```julia
canonicalize(::CompoundPeriod) -> CompoundPeriod
```

`CompoundPeriod`を次のルールを適用して標準形に減少させます：

  * より粗い`Period`によって部分的に表現可能な十分大きな`Period`は、複数の`Period`に分割されます（例：`Hour(30)`は`Day(1) + Hour(6)`になります）
  * 反対の符号を持つ`Period`は、可能な場合に結合されます（例：`Hour(1) - Day(1)`は`-Hour(23)`になります）

# 例

```jldoctest
julia> canonicalize(Dates.CompoundPeriod(Dates.Hour(12), Dates.Hour(13)))
1 day, 1 hour

julia> canonicalize(Dates.CompoundPeriod(Dates.Hour(-1), Dates.Minute(1)))
-59 minutes

julia> canonicalize(Dates.CompoundPeriod(Dates.Month(1), Dates.Week(-2)))
1 month, -2 weeks

julia> canonicalize(Dates.CompoundPeriod(Dates.Minute(50000)))
4 weeks, 6 days, 17 hours, 20 minutes
```

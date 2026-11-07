```julia
canonicalize(::CompoundPeriod)::CompoundPeriod
```

次の規則を適用して、`CompoundPeriod`を標準形に変換します。

  * より粗い`Period`で一部を表現できるほど大きな`Period`は、複数の`Period`に分割されます（例：`Hour(30)`は`Day(1) + Hour(6)`になります）。
  * 符号が反対の`Period`は、可能な場合にまとめられます（例：`Hour(1) - Day(1)`は`-Hour(23)`になります）。

# Examples

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

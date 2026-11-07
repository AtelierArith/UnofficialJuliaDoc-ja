```julia
floor(dt::TimeType, p::Period)::TimeType
```

解像度 `p` において、`dt` 以下で最も近い `Date` または `DateTime` を返します。

便宜上、`p` は値ではなく型でもかまいません。`floor(dt, Dates.Hour)` は `floor(dt, Dates.Hour(1))` の省略形です。

```jldoctest
julia> floor(Date(1985, 8, 16), Month)
1985-08-01

julia> floor(DateTime(2013, 2, 13, 0, 31, 20), Minute(15))
2013-02-13T00:30:00

julia> floor(DateTime(2016, 8, 6, 12, 0, 0), Day)
2016-08-06T00:00:00
```

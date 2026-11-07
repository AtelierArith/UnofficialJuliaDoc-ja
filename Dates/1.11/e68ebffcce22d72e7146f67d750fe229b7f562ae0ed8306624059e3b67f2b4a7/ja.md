```julia
ceil(dt::TimeType, p::Period)::TimeType
```

解像度`p`において、`dt`以上となる最小の`Date`または`DateTime`を返します。

便宜上、`p`は値ではなく型でもかまいません。`ceil(dt, Dates.Hour)`は`ceil(dt, Dates.Hour(1))`の省略形です。

```jldoctest
julia> ceil(Date(1985, 8, 16), Month)
1985-09-01

julia> ceil(DateTime(2013, 2, 13, 0, 31, 20), Minute(15))
2013-02-13T00:45:00

julia> ceil(DateTime(2016, 8, 6, 12, 0, 0), Day)
2016-08-07T00:00:00
```

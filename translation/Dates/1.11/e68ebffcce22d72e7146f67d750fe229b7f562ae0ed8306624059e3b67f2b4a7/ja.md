```julia
ceil(dt::TimeType, p::Period)::TimeType
```

解像度`p`で、`dt`以上となる最も近い`Date`または`DateTime`を返します。

便宜上、`p`には値ではなく型を指定できます。`ceil(dt, Dates.Hour)`は`ceil(dt, Dates.Hour(1))`のショートカットです。

```jldoctest
julia> ceil(Date(1985, 8, 16), Month)
1985-09-01

julia> ceil(DateTime(2013, 2, 13, 0, 31, 20), Minute(15))
2013-02-13T00:45:00

julia> ceil(DateTime(2016, 8, 6, 12, 0, 0), Day)
2016-08-07T00:00:00
```

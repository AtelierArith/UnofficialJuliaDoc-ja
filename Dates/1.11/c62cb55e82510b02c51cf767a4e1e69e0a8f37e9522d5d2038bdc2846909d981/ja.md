```julia
firstdayofmonth(dt::TimeType)::TimeType
```

`dt`を、その月の1日に調整します。

# Examples

```jldoctest
julia> firstdayofmonth(DateTime("1996-05-20"))
1996-05-01T00:00:00
```

```julia
firstdayofquarter(dt::TimeType) -> TimeType
```

`dt`をその四半期の初日に調整します。

# 例

```jldoctest
julia> firstdayofquarter(DateTime("1996-05-20"))
1996-04-01T00:00:00

julia> firstdayofquarter(DateTime("1996-08-20"))
1996-07-01T00:00:00
```

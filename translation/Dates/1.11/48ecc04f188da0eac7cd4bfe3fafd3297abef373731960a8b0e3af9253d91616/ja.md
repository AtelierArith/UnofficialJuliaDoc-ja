```julia
firstdayofyear(dt::TimeType)::TimeType
```

`dt`を、その年の初日に調整します。

# Examples

```jldoctest
julia> firstdayofyear(DateTime("1996-05-20"))
1996-01-01T00:00:00
```

```julia
lastdayofyear(dt::TimeType)::TimeType
```

`dt`を、その年の最終日に調整します。

# Examples

```jldoctest
julia> lastdayofyear(DateTime("1996-05-20"))
1996-12-31T00:00:00
```

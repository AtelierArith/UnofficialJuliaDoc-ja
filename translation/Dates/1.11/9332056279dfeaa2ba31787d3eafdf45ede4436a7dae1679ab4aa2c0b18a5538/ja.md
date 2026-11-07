```julia
eps(::Type{DateTime})::Millisecond
eps(::Type{Date})::Day
eps(::Type{Time})::Nanosecond
eps(::TimeType)::Period
```

`TimeType` がサポートする最小の単位値を返します。

# Examples

```jldoctest
julia> eps(DateTime)
1 millisecond

julia> eps(Date)
1 day

julia> eps(Time)
1 nanosecond
```

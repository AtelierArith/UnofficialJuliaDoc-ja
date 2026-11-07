```julia
dayofweek(dt::TimeType)::Int64
```

曜日を `1 = Monday, 2 = Tuesday, etc.` として返します（[`Int64`](@ref)）。

# Examples

```jldoctest
julia> dayofweek(Date("2000-01-01"))
6
```

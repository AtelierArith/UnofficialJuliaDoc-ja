```
dayofweek(dt::TimeType) -> Int64
```

Return the day of the week as an [`Int64`](@ref) with `1 = Monday, 2 = Tuesday, etc.`.

# Examples

```jldoctest
julia> dayofweek(Date("2000-01-01"))
6
```

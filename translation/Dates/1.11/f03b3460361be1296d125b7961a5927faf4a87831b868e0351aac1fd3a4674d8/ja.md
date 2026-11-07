```julia
dayofweek(dt::TimeType)::Int64
```

曜日を [`Int64`](@ref) として、`1 = Monday, 2 = Tuesday, etc.` で返します。

# Examples

```jldoctest
julia> dayofweek(Date("2000-01-01"))
6
```

```julia
dayofweek(dt::TimeType) -> Int64
```

曜日を[`Int64`](@ref)として返します。`1 = 月曜日, 2 = 火曜日, など。`

# 例

```jldoctest
julia> dayofweek(Date("2000-01-01"))
6
```

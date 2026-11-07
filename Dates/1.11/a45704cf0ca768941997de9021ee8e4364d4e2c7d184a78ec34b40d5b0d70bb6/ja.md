```julia
dayabbr(dt::TimeType; locale="english")::String
dayabbr(day::Integer; locale="english")::String
```

指定された`locale`における`Date`または`DateTime`の曜日の略称を返します。`Integer`も受け付けます。

# Examples

```jldoctest
julia> dayabbr(Date("2000-01-01"))
"Sat"

julia> dayabbr(3)
"Wed"
```

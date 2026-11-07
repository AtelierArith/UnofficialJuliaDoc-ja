```julia
dayname(dt::TimeType; locale="english")::String
dayname(day::Integer; locale="english")::String
```

指定された`locale`における`Date`または`DateTime`の曜日に対応する、曜日の正式名称を返します。`Integer`も受け付けます。

# Examples

```jldoctest
julia> dayname(Date("2000-01-01"))
"Saturday"

julia> dayname(4)
"Thursday"
```

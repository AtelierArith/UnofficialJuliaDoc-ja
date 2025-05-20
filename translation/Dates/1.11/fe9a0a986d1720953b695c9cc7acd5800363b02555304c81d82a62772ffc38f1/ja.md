```
dayabbr(dt::TimeType; locale="english") -> String
dayabbr(day::Integer; locale="english") -> String
```

指定された`locale`の曜日に対応する略称を返します。`Date`または`DateTime`の曜日を受け付けます。また、`Integer`も受け付けます。

# 例

```jldoctest
julia> dayabbr(Date("2000-01-01"))
"Sat"

julia> dayabbr(3)
"Wed"
```

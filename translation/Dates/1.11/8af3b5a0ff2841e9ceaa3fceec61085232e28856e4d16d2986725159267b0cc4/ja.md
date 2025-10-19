```julia
monthname(dt::TimeType; locale="english") -> String
monthname(month::Integer, locale="english") -> String
```

指定された`locale`で`Date`または`DateTime`または`Integer`の月のフルネームを返します。

# 例

```jldoctest
julia> monthname(Date("2005-01-04"))
"January"

julia> monthname(2)
"February"
```

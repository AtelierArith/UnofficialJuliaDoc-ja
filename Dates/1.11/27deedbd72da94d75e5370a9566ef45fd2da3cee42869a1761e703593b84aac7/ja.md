```julia
monthabbr(dt::TimeType; locale="english")::String
monthabbr(month::Integer, locale="english")::String
```

指定された`locale`に含まれる`Date`、`DateTime`、または`Integer`の月の略称を返します。

# Examples

```jldoctest
julia> monthabbr(Date("2005-01-04"))
"Jan"

julia> monthabbr(2)
"Feb"
```

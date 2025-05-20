```
monthabbr(dt::TimeType; locale="japanese") -> String
monthabbr(month::Integer, locale="japanese") -> String
```

指定された`locale`での`Date`または`DateTime`または`Integer`の省略形の月名を返します。

# 例

```jldoctest
julia> monthabbr(Date("2005-01-04"))
"Jan"

julia> monthabbr(2)
"Feb"
```

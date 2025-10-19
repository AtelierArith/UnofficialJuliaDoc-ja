```julia
daysofweekinmonth(dt::TimeType) -> Int
```

`dt`の曜日に対して、その月におけるその曜日の合計数を返します。4または5を返します。月の最終週の日を指定するために、調整関数に`dayofweekofmonth(dt) == daysofweekinmonth(dt)`を含めることで、時間的表現で便利です。

# 例

```jldoctest
julia> daysofweekinmonth(Date("2005-01-01"))
5

julia> daysofweekinmonth(Date("2005-01-04"))
4
```

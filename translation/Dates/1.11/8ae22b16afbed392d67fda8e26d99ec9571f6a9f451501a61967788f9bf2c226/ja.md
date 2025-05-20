```
daysofweekinmonth(dt::TimeType) -> Int
```

`dt`の曜日の合計数を、その月の中で返します。4または5を返します。月の中での週の最終日を指定するために、調整関数に`dayofweekofmonth(dt) == daysofweekinmonth(dt)`を含めることで、時間的な表現で役立ちます。

# 例

```jldoctest
julia> daysofweekinmonth(Date("2005-01-01"))
5

julia> daysofweekinmonth(Date("2005-01-04"))
4
```

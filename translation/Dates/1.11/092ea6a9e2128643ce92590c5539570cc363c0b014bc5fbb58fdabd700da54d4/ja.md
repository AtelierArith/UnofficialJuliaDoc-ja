```julia
daysofweekinmonth(dt::TimeType)::Int
```

`dt`の曜日が、`dt`の月に何回あるかを返します。戻り値は4または5です。調整関数に`dayofweekofmonth(dt) == daysofweekinmonth(dt)`を含めることで、月内の最終週の曜日を指定する時間式に便利です。

# Examples

```jldoctest
julia> daysofweekinmonth(Date("2005-01-01"))
5

julia> daysofweekinmonth(Date("2005-01-04"))
4
```

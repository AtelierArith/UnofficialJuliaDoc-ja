```julia
dayofweekofmonth(dt::TimeType)::Int
```

`dt`の曜日について、その曜日が`dt`の月の何回目に当たるかを返します。たとえば、`dt`の曜日が月曜日なら、`1 = First Monday of the month, 2 = Second Monday of the month, etc.`は1:5の範囲になります。

# Examples

```jldoctest
julia> dayofweekofmonth(Date("2000-02-01"))
1

julia> dayofweekofmonth(Date("2000-02-08"))
2

julia> dayofweekofmonth(Date("2000-02-15"))
3
```

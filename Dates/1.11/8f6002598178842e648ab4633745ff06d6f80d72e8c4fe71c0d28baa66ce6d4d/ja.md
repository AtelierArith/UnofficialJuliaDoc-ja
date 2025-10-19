```julia
dayofweekofmonth(dt::TimeType) -> Int
```

`dt`の曜日に対して、その月の中で何番目であるかを返します。したがって、`dt`の曜日が月曜日であれば、`1 = 月の第一月曜日、2 = 月の第二月曜日、など`となります。範囲は1:5です。

# 例

```jldoctest
julia> dayofweekofmonth(Date("2000-02-01"))
1

julia> dayofweekofmonth(Date("2000-02-08"))
2

julia> dayofweekofmonth(Date("2000-02-15"))
3
```

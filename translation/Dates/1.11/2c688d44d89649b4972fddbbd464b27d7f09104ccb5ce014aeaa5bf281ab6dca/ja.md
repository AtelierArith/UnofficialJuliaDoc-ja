```julia
daysinmonth(dt::TimeType) -> Int
```

`dt`の月の日数を返します。値は28、29、30、または31になります。

# 例

```jldoctest
julia> daysinmonth(Date("2000-01"))
31

julia> daysinmonth(Date("2001-02"))
28

julia> daysinmonth(Date("2000-02"))
29
```

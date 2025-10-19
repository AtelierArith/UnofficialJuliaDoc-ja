```julia
daysinyear(dt::TimeType) -> Int
```

`dt`の年がうるう年であれば366を返し、そうでなければ365を返します。

# 例

```jldoctest
julia> daysinyear(1999)
365

julia> daysinyear(2000)
366
```

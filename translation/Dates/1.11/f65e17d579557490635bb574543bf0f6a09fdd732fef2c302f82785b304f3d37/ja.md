```julia
daysinyear(dt::TimeType)::Int
```

`dt`の年がうるう年の場合は366を返し、そうでない場合は365を返します。

# Examples

```jldoctest
julia> daysinyear(1999)
365

julia> daysinyear(2000)
366
```

```julia
eps(::Type{DateTime}) -> ミリ秒
eps(::Type{Date}) -> 日
eps(::Type{Time}) -> ナノ秒
eps(::TimeType) -> 期間
```

`TimeType`によってサポートされる最小単位の値を返します。

# 例

```jldoctest
julia> eps(DateTime)
1 ミリ秒

julia> eps(Date)
1 日

julia> eps(Time)
1 ナノ秒
```

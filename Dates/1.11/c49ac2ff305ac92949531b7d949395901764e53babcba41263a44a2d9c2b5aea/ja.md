```
floor(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を`precision`の最も近い倍数に切り下げます。`x`と`precision`が異なるサブタイプの`Period`である場合、返される値は`precision`と同じ型になります。

便利のために、`precision`は値の代わりに型で指定することもできます：`floor(x, Dates.Hour)`は`floor(x, Dates.Hour(1))`のショートカットです。

```jldoctest
julia> floor(Day(16), Week)
2 weeks

julia> floor(Minute(44), Minute(15))
30 minutes

julia> floor(Hour(36), Day)
1 day
```

`Month`や`Year`の`precision`への切り捨てはサポートされていません。これらの`Period`は長さが不一致だからです。 ```

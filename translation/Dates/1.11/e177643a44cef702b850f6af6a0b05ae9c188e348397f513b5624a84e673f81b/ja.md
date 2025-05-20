```
ceil(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を`precision`の最も近い倍数に切り上げます。`x`と`precision`が異なる`Period`のサブタイプである場合、返される値は`precision`と同じ型になります。

便利のために、`precision`は値の代わりに型で指定することもできます：`ceil(x, Dates.Hour)`は`ceil(x, Dates.Hour(1))`のショートカットです。

```jldoctest
julia> ceil(Day(16), Week)
3 weeks

julia> ceil(Minute(44), Minute(15))
45 minutes

julia> ceil(Hour(36), Day)
2 days
```

`Month`や`Year`の`precision`への切り上げはサポートされていません。これらの`Period`は長さが不一致だからです。 ```

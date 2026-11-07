```julia
floor(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を`precision`の最も近い倍数に切り下げます。`x`と`precision`が`Period`の異なるサブタイプである場合、戻り値の型は`precision`と同じになります。

便宜上、`precision`には値ではなく型を指定できます。`floor(x, Dates.Hour)`は`floor(x, Dates.Hour(1))`の省略形です。

```jldoctest
julia> floor(Day(16), Week)
2 weeks

julia> floor(Minute(44), Minute(15))
30 minutes

julia> floor(Hour(36), Day)
1 day
```

`Month`または`Year`の`precision`への丸めはサポートされていません。これらの`Period`は長さが一定ではないためです。

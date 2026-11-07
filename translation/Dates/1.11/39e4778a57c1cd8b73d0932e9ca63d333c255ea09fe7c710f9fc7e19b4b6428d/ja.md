```julia
ceil(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を、`precision`の最も近い倍数に切り上げます。`x`と`precision`が`Period`の異なるサブタイプである場合、戻り値の型は`precision`と同じになります。

便宜上、`precision`には値ではなく型を指定できます。`ceil(x, Dates.Hour)`は`ceil(x, Dates.Hour(1))`の省略形です。

```jldoctest
julia> ceil(Day(16), Week)
3 weeks

julia> ceil(Minute(44), Minute(15))
45 minutes

julia> ceil(Hour(36), Day)
2 days
```

`Month`または`Year`の`precision`への丸めはサポートされていません。これらの`Period`の長さは一定ではないためです。

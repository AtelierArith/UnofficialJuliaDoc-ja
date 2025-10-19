```julia
round(x::Period, precision::T, [r::RoundingMode]) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を`precision`の最も近い倍数に丸めます。`x`と`precision`が異なる`Period`のサブタイプである場合、返される値は`precision`と同じ型になります。デフォルトでは（`RoundNearestTiesUp`）、同点（例：90分を最も近い時間に丸める）は切り上げられます。

便利のために、`precision`は値の代わりに型で指定することもできます：`round(x, Dates.Hour)`は`round(x, Dates.Hour(1))`のショートカットです。

```jldoctest
julia> round(Day(16), Week)
2 weeks

julia> round(Minute(44), Minute(15))
45 minutes

julia> round(Hour(36), Day)
2 days
```

`round(::Period, ::T, ::RoundingMode)`の有効な丸めモードは`RoundNearestTiesUp`（デフォルト）、`RoundDown`（`floor`）、および`RoundUp`（`ceil`）です。

`Month`や`Year`の`precision`への丸めはサポートされていません。これらの`Period`は長さが不一致だからです。

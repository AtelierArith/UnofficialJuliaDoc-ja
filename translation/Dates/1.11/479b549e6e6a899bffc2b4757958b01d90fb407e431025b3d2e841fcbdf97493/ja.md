```julia
round(dt::TimeType, p::Period, [r::RoundingMode]) -> TimeType
```

`dt`に最も近い`Date`または`DateTime`を解像度`p`で返します。デフォルトでは（`RoundNearestTiesUp`）、同点（例：9:30を最も近い時間に丸める）は切り上げられます。

便利のために、`p`は値の代わりに型で指定することもできます：`round(dt, Dates.Hour)`は`round(dt, Dates.Hour(1))`のショートカットです。

```jldoctest
julia> round(Date(1985, 8, 16), Month)
1985-08-01

julia> round(DateTime(2013, 2, 13, 0, 31, 20), Minute(15))
2013-02-13T00:30:00

julia> round(DateTime(2016, 8, 6, 12, 0, 0), Day)
2016-08-07T00:00:00
```

`round(::TimeType, ::Period, ::RoundingMode)`の有効な丸めモードは`RoundNearestTiesUp`（デフォルト）、`RoundDown`（`floor`）、および`RoundUp`（`ceil`）です。

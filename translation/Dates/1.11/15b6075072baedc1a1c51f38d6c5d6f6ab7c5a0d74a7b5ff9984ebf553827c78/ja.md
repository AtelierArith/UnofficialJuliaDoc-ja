```julia
round(dt::TimeType, p::Period, [r::RoundingMode]) -> TimeType
```

解像度`p`で、`dt`に最も近い`Date`または`DateTime`を返します。デフォルト（`RoundNearestTiesUp`）では、ちょうど中間の場合（たとえば、9:30を最も近い時間に丸める場合）は切り上げます。

便宜上、`p`には値ではなく型を指定できます。`round(dt, Dates.Hour)`は`round(dt, Dates.Hour(1))`の省略形です。

```jldoctest
julia> round(Date(1985, 8, 16), Month)
1985-08-01

julia> round(DateTime(2013, 2, 13, 0, 31, 20), Minute(15))
2013-02-13T00:30:00

julia> round(DateTime(2016, 8, 6, 12, 0, 0), Day)
2016-08-07T00:00:00
```

`round(::TimeType, ::Period, ::RoundingMode)`で有効な丸めモードは、`RoundNearestTiesUp`（デフォルト）、`RoundDown`（`floor`）、および`RoundUp`（`ceil`）です。

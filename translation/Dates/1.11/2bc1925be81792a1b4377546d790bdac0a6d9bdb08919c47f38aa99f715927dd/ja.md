```julia
round(x::Period, precision::T, [r::RoundingMode]) where T <: Union{TimePeriod, Week, Day} -> T
```

`x`を`precision`の最も近い倍数に丸めます。`x`と`precision`が`Period`の異なるサブタイプである場合、戻り値の型は`precision`と同じになります。デフォルト（`RoundNearestTiesUp`）では、ちょうど中間の値（たとえば、90分を最も近い時間に丸める場合）は切り上げられます。

便宜上、`precision`には値ではなく型を指定できます。`round(x, Dates.Hour)`は`round(x, Dates.Hour(1))`の省略形です。

```jldoctest
julia> round(Day(16), Week)
2 weeks

julia> round(Minute(44), Minute(15))
45 minutes

julia> round(Hour(36), Day)
2 days
```

`round(::Period, ::T, ::RoundingMode)`で有効な丸めモードは、`RoundNearestTiesUp`（デフォルト）、`RoundDown`（`floor`）、および`RoundUp`（`ceil`）です。

`precision`を`Month`または`Year`の単位に丸めることはできません。これらの`Period`は長さが一定ではないためです。

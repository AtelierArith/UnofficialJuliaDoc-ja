```julia
adjust(df, start[, step, limit])::TimeType
adjust(df, start)::TimeType
```

`start` の日付を、`df` を使って `f::Function` を通過したと判定されるまで調整し、`true` を返します。省略可能な `step` パラメーターは、各反復で `start` をどのように変更するかを指定します。`limit` 回の反復が発生すると、[`ArgumentError`](@ref) がスローされます。

パラメーター `start` と `limit` のデフォルト値は、それぞれ 1 日と 10,000 です。

# Examples

```jldoctest
julia> Dates.adjust(date -> month(date) == 10, Date(2022, 1, 1), step=Month(3), limit=10)
2022-10-01

julia> Dates.adjust(date -> year(date) == 2025, Date(2022, 1, 1), step=Year(1), limit=4)
2025-01-01

julia> Dates.adjust(date -> day(date) == 15, Date(2022, 1, 1), step=Year(1), limit=3)
ERROR: ArgumentError: Adjustment limit reached: 3 iterations
Stacktrace:
[...]

julia> Dates.adjust(date -> month(date) == 10, Date(2022, 1, 1))
2022-10-01

julia> Dates.adjust(date -> year(date) == 2025, Date(2022, 1, 1))
2025-01-01

julia> Dates.adjust(date -> year(date) == 2224, Date(2022, 1, 1))
ERROR: ArgumentError: Adjustment limit reached: 10000 iterations
Stacktrace:
[...]
```

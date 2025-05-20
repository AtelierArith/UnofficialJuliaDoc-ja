```
adjust(df, start[, step, limit]) -> TimeType
adjust(df, start) -> TimeType
```

Adjusts the date in `start` until the `f::Function` passed using `df` returns `true`. The optional `step` parameter dictates the change in `start` on every iteration. If `limit` iterations occur, then an [`ArgumentError`](@ref) is thrown.

The default values for parameters `start` and `limit` are 1 Day and 10,000 respectively.

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

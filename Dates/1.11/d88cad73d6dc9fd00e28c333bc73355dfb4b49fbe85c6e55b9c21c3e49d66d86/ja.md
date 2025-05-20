```
adjust(df, start[, step, limit]) -> TimeType
adjust(df, start) -> TimeType
```

`start`の日時を`df`を使用して渡された`f::Function`が`true`を返すまで調整します。オプションの`step`パラメータは、各イテレーションで`start`の変更を指示します。`limit`回のイテレーションが発生した場合、[`ArgumentError`](@ref)がスローされます。

パラメータ`start`と`limit`のデフォルト値はそれぞれ1日と10,000です。

# 例

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

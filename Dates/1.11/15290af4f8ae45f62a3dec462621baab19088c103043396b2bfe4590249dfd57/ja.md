```julia
Dates.ISODateTimeFormat
```

日付と時刻のISO8601フォーマットを説明します。これは`DateTime`の`Dates.format`のデフォルト値です。

# 例

```jldoctest
julia> Dates.format(DateTime(2018, 8, 8, 12, 0, 43, 1), ISODateTimeFormat)
"2018-08-08T12:00:43.001"
```

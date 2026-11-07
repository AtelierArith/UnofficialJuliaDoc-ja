```julia
Dates.ISODateTimeFormat
```

日付と時刻の ISO 8601 形式を表します。これは、`DateTime` の `Dates.format` のデフォルト値です。

# Examples

```jldoctest
julia> Dates.format(DateTime(2018, 8, 8, 12, 0, 43, 1), ISODateTimeFormat)
"2018-08-08T12:00:43.001"
```

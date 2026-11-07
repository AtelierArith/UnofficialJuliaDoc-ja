```julia
Dates.ISOTimeFormat
```

時刻のISO8601形式を表します。これは、`Time`の`Dates.format`のデフォルト値です。

# Examples

```jldoctest
julia> Dates.format(Time(12, 0, 43, 1), ISOTimeFormat)
"12:00:43.001"
```

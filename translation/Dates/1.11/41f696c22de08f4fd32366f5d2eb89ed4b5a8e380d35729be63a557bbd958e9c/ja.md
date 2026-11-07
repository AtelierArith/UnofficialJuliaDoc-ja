```julia
Dates.ISOTimeFormat
```

時刻の ISO8601 形式を表します。これは、`Dates.format` の `Time` におけるデフォルト値です。

# Examples

```jldoctest
julia> Dates.format(Time(12, 0, 43, 1), ISOTimeFormat)
"12:00:43.001"
```

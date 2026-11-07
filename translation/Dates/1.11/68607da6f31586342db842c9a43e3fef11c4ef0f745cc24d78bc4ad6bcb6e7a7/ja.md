```julia
Dates.ISODateFormat
```

日付の ISO 8601 形式を指定します。これは、`Date` の `Dates.format` のデフォルト値です。

# Examples

```jldoctest
julia> Dates.format(Date(2018, 8, 8), ISODateFormat)
"2018-08-08"
```

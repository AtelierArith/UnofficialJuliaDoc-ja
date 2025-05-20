```
Dates.ISODateFormat
```

日付のISO8601フォーマットを説明します。これは`Date`の`Dates.format`のデフォルト値です。

# 例

```jldoctest
julia> Dates.format(Date(2018, 8, 8), ISODateFormat)
"2018-08-08"
```

```julia
Dates.RFC1123Format
```

日付と時刻のRFC1123形式を説明します。

# 例

```jldoctest
julia> Dates.format(DateTime(2018, 8, 8, 12, 0, 43, 1), RFC1123Format)
"Wed, 08 Aug 2018 12:00:43"
```

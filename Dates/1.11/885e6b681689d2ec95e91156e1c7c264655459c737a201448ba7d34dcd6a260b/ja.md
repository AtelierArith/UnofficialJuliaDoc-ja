```
DateTime(dt::AbstractString, df::DateFormat=ISODateTimeFormat) -> DateTime
```

`dt` 日付時刻文字列を [`DateFormat`](@ref) オブジェクトで指定されたパターンに従って解析することによって `DateTime` を構築します。省略した場合は dateformat"yyyy-mm-dd\THH:MM:SS.s" になります。

`DateTime(::AbstractString, ::AbstractString)` に似ていますが、事前に作成された `DateFormat` オブジェクトを使用して、同様の形式の日時文字列を繰り返し解析する際により効率的です。

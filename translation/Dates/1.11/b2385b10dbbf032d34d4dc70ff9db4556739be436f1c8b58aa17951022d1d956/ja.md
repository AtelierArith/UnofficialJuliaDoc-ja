```julia
DateTime(dt::AbstractString, df::DateFormat=ISODateTimeFormat)
```

`dt` の日時文字列を、[`DateFormat`](@ref) オブジェクトで指定されたパターン（省略時は dateformat"yyyy-mm-dd\THH:MM:SS.s"）に従って解析し、`DateTime` を構築します。

`DateTime(::AbstractString, ::AbstractString)` と同様ですが、あらかじめ作成した `DateFormat` オブジェクトを使うことで、同じ形式の日時文字列を繰り返し解析する場合に、より効率的です。

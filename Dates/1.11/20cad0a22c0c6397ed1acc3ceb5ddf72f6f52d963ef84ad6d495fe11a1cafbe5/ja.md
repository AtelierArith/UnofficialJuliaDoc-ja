```julia
Time(t::AbstractString, df::DateFormat=ISOTimeFormat)
```

`t` の日時文字列を、[`DateFormat`](@ref) オブジェクトで指定されたパターン（省略時は dateformat"HH:MM:SS.s"）に従って解析し、`Time` を構築します。

`Time(::AbstractString, ::AbstractString)` と似ていますが、あらかじめ作成した `DateFormat` オブジェクトを使って、同じ形式の時刻文字列を繰り返し解析する場合に、より効率的です。

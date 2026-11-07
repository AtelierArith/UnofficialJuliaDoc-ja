```julia
Time(t::AbstractString, df::DateFormat=ISOTimeFormat)
```

`t`の日付時刻文字列を、[`DateFormat`](@ref)オブジェクトで指定されたパターンに従って解析し、`Time`を構築します。パターンを省略した場合は、dateformat"HH:MM:SS.s"が使われます。

`Time(::AbstractString, ::AbstractString)`と同様ですが、あらかじめ作成した`DateFormat`オブジェクトを使うことで、同じ形式の時刻文字列を繰り返し解析する場合に、より効率的です。

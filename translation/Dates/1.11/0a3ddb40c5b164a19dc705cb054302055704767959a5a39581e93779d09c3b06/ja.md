```julia
Date(d::AbstractString, df::DateFormat=ISODateFormat)
```

[`DateFormat`](@ref) オブジェクトで指定されたパターンに従って `d` の日付文字列を解析し、`Date` を構築します。パターンが省略された場合は、dateformat"yyyy-mm-dd" を使用します。

`Date(::AbstractString, ::AbstractString)` と同様ですが、あらかじめ作成した `DateFormat` オブジェクトを使うため、同じ形式の日付文字列を繰り返し解析する場合により効率的です。

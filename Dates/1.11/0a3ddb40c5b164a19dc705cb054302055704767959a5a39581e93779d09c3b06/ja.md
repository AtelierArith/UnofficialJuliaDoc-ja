```julia
Date(d::AbstractString, df::DateFormat=ISODateFormat)
```

`d`の日付文字列を、[`DateFormat`](@ref)オブジェクトで指定されたパターン（省略時はdateformat"yyyy-mm-dd"）に従って解析し、`Date`を構築します。

`Date(::AbstractString, ::AbstractString)`と同様ですが、あらかじめ作成した`DateFormat`オブジェクトを使うため、同じ形式の日付文字列を繰り返し解析する場合により効率的です。

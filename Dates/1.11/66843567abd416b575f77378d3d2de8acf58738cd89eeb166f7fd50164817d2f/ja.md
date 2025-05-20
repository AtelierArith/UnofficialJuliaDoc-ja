```
Date(d::AbstractString, df::DateFormat=ISODateFormat) -> Date
```

`d`の日付文字列を[`DateFormat`](@ref)オブジェクトで指定されたパターンに従って解析することによって`Date`を構築します。省略した場合はdateformat"yyyy-mm-dd"が使用されます。

`Date(::AbstractString, ::AbstractString)`に似ていますが、事前に作成された`DateFormat`オブジェクトを使用して、同様の形式の日付文字列を繰り返し解析する際により効率的です。

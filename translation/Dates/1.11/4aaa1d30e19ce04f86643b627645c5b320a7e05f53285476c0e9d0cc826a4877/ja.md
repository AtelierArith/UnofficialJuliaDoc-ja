```
Time(t::AbstractString, df::DateFormat=ISOTimeFormat) -> Time
```

`Time`を構築するには、指定された[`DateFormat`](@ref)オブジェクトに従って`t`の日付時刻文字列を解析します。省略した場合は、dateformat"HH:MM:SS.s"が使用されます。

`Time(::AbstractString, ::AbstractString)`に似ていますが、事前に作成された`DateFormat`オブジェクトを使用することで、同様の形式の時間文字列を繰り返し解析する際により効率的です。

```
floor([T,] x)
floor(x; digits::Integer= [, base = 10])
floor(x; sigdigits::Integer= [, base = 10])
```

`floor(x)` は、`x` 以下の同じ型の最も近い整数値を返します。

`floor(T, x)` は、結果を型 `T` に変換し、切り捨てた値が `T` で表現できない場合は `InexactError` をスローします。

キーワード `digits`、`sigdigits` および `base` は [`round`](@ref) と同様に機能します。

新しい型に対して `floor` をサポートするには、`Base.round(x::NewType, ::RoundingMode{:Down})` を定義します。

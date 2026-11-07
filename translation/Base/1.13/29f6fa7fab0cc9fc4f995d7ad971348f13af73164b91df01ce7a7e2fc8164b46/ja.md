```julia
floor([T,] x)
floor(x; digits::Integer= [, base = 10])
floor(x; sigdigits::Integer= [, base = 10])
```

`floor(x)` は、`x` 以下の値のうち、`x` と同じ型で最も近い整数値を返します。

`floor(T, x)` は、結果を `T` 型に変換します。切り捨てた値を `T` で表現できない場合は、`InexactError` をスローします。

キーワード `digits`、`sigdigits`、`base` の動作は、[`round`](@ref) と同じです。

新しい型で `floor` をサポートするには、`Base.round(x::NewType, ::RoundingMode{:Down})` を定義します。

```julia
ceil([T,] x)
ceil(x; digits::Integer= [, base = 10])
ceil(x; sigdigits::Integer= [, base = 10])
```

`ceil(x)` は、`x` 以上となる、`x` と同じ型の最も近い整数値を返します。

`ceil(T, x)` は、結果を `T` 型に変換します。切り上げた値を `T` として表現できない場合は、`InexactError` をスローします。

キーワード `digits`、`sigdigits`、`base` の動作は、[`round`](@ref) と同じです。

新しい型で `ceil` をサポートするには、`Base.round(x::NewType, ::RoundingMode{:Up})` を定義します。

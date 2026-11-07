```julia
BroadcastStyle(::Style1, ::Style2) = Style3()
```

異なる`BroadcastStyle`をどのように解決するかを指定します。たとえば、

```julia
BroadcastStyle(::Primary, ::Secondary) = Primary()
```

は、スタイル`Primary`が`Secondary`より優先されることを示します。引数の両方の順序を定義する必要はありません（通常は定義すべきではありません）。結果は入力引数のいずれかである必要はなく、3つ目の型でもかまいません。

詳しくは、マニュアルの[Interfaces chapter](@ref man-interfaces-broadcasting)をご覧ください。

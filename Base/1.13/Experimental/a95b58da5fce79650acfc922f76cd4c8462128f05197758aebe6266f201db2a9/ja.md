```julia
Experimental.show_error_hints(io, ex, args...)
```

特定の例外型 `typeof(ex)` とそのすべてのスーパータイプについて、[`Experimental.register_error_hint`](@ref) のすべてのハンドラーを呼び出します。`args` には、その型のハンドラーが必要とするその他の引数をすべて指定してください。

!!! compat "Julia 1.5"
    カスタムエラーヒントは Julia 1.5 以降で利用できます。


!!! warning
    このインターフェースは実験的なものであり、予告なく変更または削除される場合があります。


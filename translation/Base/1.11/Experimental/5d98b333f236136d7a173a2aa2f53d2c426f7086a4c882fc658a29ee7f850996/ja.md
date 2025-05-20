```
Experimental.show_error_hints(io, ex, args...)
```

特定の例外タイプ `typeof(ex)` に対して [`Experimental.register_error_hint`](@ref) からすべてのハンドラーを呼び出します。 `args` には、そのタイプのハンドラーが期待する他の引数が含まれている必要があります。

!!! compat "Julia 1.5"
    カスタムエラーヒントはJulia 1.5以降で利用可能です。


!!! warning
    このインターフェースは実験的であり、予告なしに変更または削除される可能性があります。


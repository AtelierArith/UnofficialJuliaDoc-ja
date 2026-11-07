```julia
Meta.reescape(unescaped_expr, original_expr)
```

`unescaped_expr` を、`original_expr` と同じレベルでエスケープし直します。これは [`unescape`](@ref) の逆の操作です。元の式がエスケープされていた場合は、エスケープを解除した式を再び `:escape` で囲みます。

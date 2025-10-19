```julia
redisplay(x)
redisplay(d::AbstractDisplay, x)
redisplay(mime, x)
redisplay(d::AbstractDisplay, mime, x)
```

デフォルトでは、`redisplay` 関数は単に [`display`](@ref) を呼び出します。しかし、一部の表示バックエンドは、既存の `x` の表示を変更するために `redisplay` をオーバーライドする場合があります（もしあれば）。`redisplay` を使用することは、バックエンドに対して `x` が何度も再表示される可能性があることを示すヒントでもあり、バックエンドは（例えば）次の対話型プロンプトまで表示を遅延させることを選択するかもしれません。

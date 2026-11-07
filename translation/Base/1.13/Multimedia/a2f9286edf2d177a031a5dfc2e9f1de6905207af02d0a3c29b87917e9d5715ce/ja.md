```julia
redisplay(x)
redisplay(d::AbstractDisplay, x)
redisplay(mime, x)
redisplay(d::AbstractDisplay, mime, x)
```

デフォルトでは、`redisplay` 関数は単に [`display`](@ref) を呼び出します。ただし、一部の表示バックエンドでは、`redisplay` をオーバーライドして、既存の `x` の表示（存在する場合）を変更できます。また、`redisplay` を使うと、`x` が何度か再表示される可能性があることをバックエンドに示せます。そのため、バックエンドは（たとえば）次の対話プロンプトが表示されるまで、表示を保留することがあります。

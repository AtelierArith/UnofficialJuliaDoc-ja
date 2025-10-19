`HTML(s)`: `s`をhtmlとしてレンダリングするオブジェクトを作成します。

```julia
HTML("<div>foo</div>")
```

大量のデータの場合はストリームを使用することもできます：

```julia
HTML() do io
  println(io, "<div>foo</div>")
end
```

!!! warning
    `HTML`は現在、後方互換性を維持するためにエクスポートされていますが、このエクスポートは非推奨です。この型は[`Docs.HTML`](@ref)として使用するか、`Docs`から明示的にインポートすることをお勧めします。


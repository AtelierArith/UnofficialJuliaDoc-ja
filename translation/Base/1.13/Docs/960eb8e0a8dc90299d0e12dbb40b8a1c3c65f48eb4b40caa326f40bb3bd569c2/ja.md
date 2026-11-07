`HTML(s)`: `s` を HTML としてレンダリングするオブジェクトを作成します。

```julia
HTML("<div>foo</div>")
```

大量のデータを扱う場合は、ストリームも使用できます。

```julia
HTML() do io
  println(io, "<div>foo</div>")
end
```

!!! warning
    `HTML` は後方互換性を維持するために現在もエクスポートされていますが、このエクスポートは非推奨です。この型は [`Docs.HTML`](@ref) として使用するか、`Docs` から明示的にインポートすることを推奨します。


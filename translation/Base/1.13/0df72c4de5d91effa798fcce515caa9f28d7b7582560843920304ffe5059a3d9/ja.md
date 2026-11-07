```julia
extendedterminfo(data::IO; NumInt::Union{Type{Int16}, Type{Int32}})
```

`data`から拡張terminfoセクションを読み込みます。数値型には`NumInt`を使用します。

`term(5)`に準拠するterminfoコンテンツであれば、どのようなものでも受け付けます。

関連項目: `read(::IO, ::Type{TermInfoRaw})`

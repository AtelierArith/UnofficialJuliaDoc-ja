```julia
undocumented_names(mod::Module; private=false)
```

`module`内の文書化されていないシンボルのソートされたベクターを返します（つまり、ドキュメント文字列が欠如しているもの）。`private=false`（デフォルト）では、`public`および/または`export`で宣言された識別子のみを返しますが、`private=true`ではモジュール内のすべてのシンボルを返します（`#`で始まるコンパイラ生成の隠しシンボルは除外されます）。

関連情報: [`names`](@ref), [`Docs.hasdoc`](@ref), [`Base.ispublic`](@ref).

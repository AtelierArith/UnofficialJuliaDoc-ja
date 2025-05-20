```
undocumented_names(mod::Module; private=false)
```

ドキュメントがないシンボルのソートされたベクターを `module` から返します（つまり、ドキュメント文字列が欠けているもの）。`private=false`（デフォルト）では、`public` および/または `export` で宣言された識別子のみを返しますが、`private=true` ではモジュール内のすべてのシンボルを返します（コンパイラ生成の隠しシンボルである `#` で始まるものは除く）。

関連情報: [`names`](@ref), [`Docs.hasdoc`](@ref), [`Base.ispublic`](@ref).

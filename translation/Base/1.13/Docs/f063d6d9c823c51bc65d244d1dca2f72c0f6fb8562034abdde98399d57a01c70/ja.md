```julia
Docs.metadata(source, module, expr, ismodule)
```

`expr`から取得したメタデータを含む`Dict`式を構築します。

返される`Dict`には、次のフィールドを含めることができます。

  * `:path`:       `expr`が定義されているファイルを表すシンボル。
  * `:linenumber`: `expr`が定義されている行番号。
  * `:module`: docstringが定義されているモジュール。
  * `:fields`: `expr`で見つかったすべてのフィールドドキュメントの`Dict`。具象型に限ります。

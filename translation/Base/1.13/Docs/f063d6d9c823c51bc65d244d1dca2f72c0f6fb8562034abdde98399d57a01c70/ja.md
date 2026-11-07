```julia
Docs.metadata(source, module, expr, ismodule)
```

`expr` 式から取得したメタデータを含む `Dict` 式を構築します。

返される `Dict` に含められるフィールド:

  * `:path`:       `expr` が定義されているファイルを表すシンボル。
  * `:linenumber`: `expr` が定義されている行番号。
  * `:module`:     docstring が定義されているモジュール。
  * `:fields`:     `expr` で見つかったすべてのフィールドドキュメントの `Dict`。具象型の場合のみ。

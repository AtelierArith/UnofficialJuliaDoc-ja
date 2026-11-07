```julia
getdoc(obj)
getdoc(obj, sig)
```

オブジェクト `obj` に関連付けられたカスタム docstring オブジェクトを返します。必要に応じて、タプル型シグネチャ `sig` も指定できます。`sig` に指定できる値については、`MultiDoc` のドキュメントを参照してください。

返されるオブジェクトには、`Markdown.parse` で生成された Markdown オブジェクトのほか、Markdown 以外の形式のドキュメントを表示するためのカスタム型も使用できます。

`nothing` を返すと、`obj` のドキュメントが見つからなかったことを docsystem に伝えられます。その場合、docsystem は代わりに `obj` に関連付けられた `Binding` を検索します。

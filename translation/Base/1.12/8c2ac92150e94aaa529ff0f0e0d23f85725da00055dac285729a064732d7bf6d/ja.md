```julia
propertynames(x, private=false)
```

オブジェクト `x` のプロパティ（`x.property`）のタプルまたはベクターを取得します。これは通常、[`fieldnames(typeof(x))`](@ref) と同じですが、[`getproperty`](@ref) をオーバーロードするタイプは、タイプのインスタンスのプロパティを取得するために `propertynames` もオーバーロードする必要があります。

`propertynames(x)` は、`x` の文書化されたインターフェースの一部である「公開」プロパティ名のみを返す場合があります。内部使用を目的とした「プライベート」プロパティ名も返すようにしたい場合は、オプションの第二引数に `true` を渡してください。`x.` に対する REPL のタブ補完は、`private=false` のプロパティのみを表示します。

関連情報: [`hasproperty`](@ref), [`hasfield`](@ref).

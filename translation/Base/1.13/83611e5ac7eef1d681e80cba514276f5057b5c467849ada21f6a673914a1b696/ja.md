```julia
propertynames(x, private=false)
```

オブジェクト `x` のプロパティ（`x.property`）をタプルまたはベクトルとして取得します。通常、これは [`fieldnames(typeof(x))`](@ref) と同じですが、[`getproperty`](@ref) をオーバーロードする型では、その型のインスタンスのプロパティを取得できるよう、一般に `propertynames` もオーバーロードする必要があります。

`propertynames(x)` が返すのは、`x` のドキュメント化されたインターフェースに含まれる「public」なプロパティ名だけの場合があります。内部利用を目的とした「private」なプロパティ名も返すには、2番目の省略可能な引数に `true` を渡します。REPL で `x.` のタブ補完を使うと、`private=false` プロパティだけが表示されます。

関連項目: [`hasproperty`](@ref)、[`hasfield`](@ref)。

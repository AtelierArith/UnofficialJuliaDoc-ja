```julia
propertynames(x, private=false)
```

オブジェクト `x` のプロパティ（`x.property`）をタプルまたはベクトルとして取得します。通常、これは [`fieldnames(typeof(x))`](@ref) と同じです。ただし、[`getproperty`](@ref) をオーバーロードする型では、その型のインスタンスのプロパティを取得できるよう、一般に `propertynames` もオーバーロードする必要があります。

`propertynames(x)` が返すのは、`x` のドキュメント化されたインターフェースに含まれる「パブリック」なプロパティ名だけの場合があります。内部使用を目的とした「プライベート」なプロパティ名も返すには、2 番目の省略可能な引数に `true` を渡します。REPL で `x.` のタブ補完に表示されるのは、`private=false` プロパティだけです。

関連項目: [`hasproperty`](@ref)、[`hasfield`](@ref)。

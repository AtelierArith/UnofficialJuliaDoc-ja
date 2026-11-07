```julia
Base.dataids(A::AbstractArray)
```

配列の可変データセグメントを表す`UInt`のタプルを返します。

構成要素のエイリアス検出を有効にしたいカスタム配列は、このメソッドを特殊化して、構成要素の`dataids`を連結したものを返すようにできます。親配列をラップする配列では、通常、次のように定義します。`Base.dataids(C::CustomArray) = dataids(C.parent)`

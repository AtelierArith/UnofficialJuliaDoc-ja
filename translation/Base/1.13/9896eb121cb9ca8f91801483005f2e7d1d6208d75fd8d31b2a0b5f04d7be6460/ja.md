```julia
trylock(lock) -> Success (Boolean)
```

ロックが利用可能であれば取得し、成功した場合は `true` を返します。ロックがすでに別のタスク／スレッドによって取得されている場合は、`false` を返します。

成功した `trylock` には、それぞれ [`unlock`](@ref) を対応させる必要があります。

`trylock` と [`islocked`](@ref) を組み合わせると、`typeof(lock)` がサポートしている場合に、test-and-test-and-set アルゴリズムや指数バックオフアルゴリズムを実装できます（ドキュメントを参照してください）。

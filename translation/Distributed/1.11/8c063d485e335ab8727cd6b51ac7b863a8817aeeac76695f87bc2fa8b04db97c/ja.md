```julia
CachingPool(workers::Vector{Int})
```

`AbstractWorkerPool` の実装では、[`remote`](@ref)、[`remotecall_fetch`](@ref)、[`pmap`](@ref)（および関数をリモートで実行するその他のリモート呼び出し）において、シリアライズ／デシリアライズした関数をワーカーノード上にキャッシュすると効果があります。特に、クロージャ（大量のデータをキャプチャする場合があります）で有効です。

リモートキャッシュは、返された `CachingPool` オブジェクトの存続期間中保持されます。キャッシュをそれより早くクリアするには、`clear!(pool)` を使用します。

グローバル変数については、クロージャにキャプチャされるのはバインディングのみで、データ自体はキャプチャされません。グローバルデータをキャプチャするには、`let` ブロックを使用できます。

# Examples

```julia
const foo = rand(10^8);
wp = CachingPool(workers())
let foo = foo
    pmap(i -> sum(foo) + i, wp, 1:100);
end
```

上記の方法では、`foo` は各ワーカーに一度だけ転送されます。

```julia
CachingPool(workers::Vector{Int})
```

`AbstractWorkerPool` の実装では、[`remote`](@ref)、[`remotecall_fetch`](@ref)、[`pmap`](@ref)（および関数をリモートで実行するその他のリモート呼び出し）において、シリアライズ／デシリアライズされた関数をワーカーノード上にキャッシュすると効果的です。特に、大量のデータをキャプチャすることがあるクロージャでは有効です。

リモートキャッシュは、返された `CachingPool` オブジェクトが存続する間保持されます。キャッシュをそれより早くクリアするには、`clear!(pool)` を使用します。

グローバル変数については、クロージャにキャプチャされるのはバインディングのみで、データそのものではありません。グローバルデータをキャプチャするには、`let` ブロックを使用できます。

# Examples

```julia
const foo = rand(10^8);
wp = CachingPool(workers())
let foo = foo
    pmap(i -> sum(foo) + i, wp, 1:100);
end
```

上記の方法では、`foo` は各ワーカーに一度だけ転送されます。

```julia
CachingPool(workers::Vector{Int})
```

`AbstractWorkerPool`の実装です。 [`remote`](@ref), [`remotecall_fetch`](@ref), [`pmap`](@ref)（および関数をリモートで実行する他のリモート呼び出し）は、特にクロージャ（大量のデータをキャプチャする可能性がある）において、ワーカーノード上でシリアライズ/デシリアライズされた関数をキャッシュすることで恩恵を受けます。

リモートキャッシュは、返された`CachingPool`オブジェクトのライフタイムの間維持されます。キャッシュを早期にクリアするには、`clear!(pool)`を使用します。

グローバル変数については、クロージャ内でキャプチャされるのはバインディングのみで、データはキャプチャされません。グローバルデータをキャプチャするには、`let`ブロックを使用できます。

# 例

```julia
const foo = rand(10^8);
wp = CachingPool(workers())
let foo = foo
    pmap(i -> sum(foo) + i, wp, 1:100);
end
```

上記は、`foo`を各ワーカーに一度だけ転送します。

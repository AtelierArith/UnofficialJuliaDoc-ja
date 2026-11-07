```julia
AbstractWorkerPool
```

[`WorkerPool`](@ref)や[`CachingPool`](@ref)などのワーカープールのスーパータイプです。`AbstractWorkerPool`では、次の処理を実装する必要があります。

  * [`push!`](@ref) - ワーカーを全体のプール（利用可能なワーカーと使用中のワーカー）に追加する
  * [`put!`](@ref) - ワーカーを利用可能なワーカーのプールに戻す
  * [`take!`](@ref) - 利用可能なワーカーのプールからワーカーを取得する（リモート関数の実行に使用）
  * [`wait`](@ref) - ワーカーが利用可能になるまでブロックする
  * [`length`](@ref) - 全体のプールで利用可能なワーカーの数を返す
  * [`isready`](@ref) - プールに対する`take!`がブロックする場合はfalseを、そうでなければtrueを返す

上記のデフォルト実装（`AbstractWorkerPool`の場合）では、次のフィールドが必要です。

  * `channel::Channel{Int}`
  * `workers::Set{Int}`

`channel`には空きワーカーのpidが格納され、`workers`はこのプールに属するすべてのワーカーの集合です。

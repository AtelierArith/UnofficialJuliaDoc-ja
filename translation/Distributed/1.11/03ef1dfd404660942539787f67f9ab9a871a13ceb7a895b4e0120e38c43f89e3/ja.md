```julia
AbstractWorkerPool
```

[`WorkerPool`](@ref)や[`CachingPool`](@ref)などのワーカープールのスーパータイプです。`AbstractWorkerPool`では、次の機能を実装する必要があります。

  * [`push!`](@ref) - 全体のプール（利用可能なワーカーと使用中のワーカー）に新しいワーカーを追加する
  * [`put!`](@ref) - ワーカーを利用可能なプールに戻す
  * [`take!`](@ref) - 利用可能なプールからワーカーを取得する（リモート関数の実行に使用）
  * [`wait`](@ref) - ワーカーが利用可能になるまでブロックする
  * [`length`](@ref) - 全体のプールで利用可能なワーカー数を返す
  * [`isready`](@ref) - プールに対する`take!`がブロックする場合はfalseを、そうでなければtrueを返す

上記のデフォルト実装（`AbstractWorkerPool`の場合）では、次のフィールドが必要です。

  * `channel::Channel{Int}`
  * `workers::Set{Int}`

`channel`には空きワーカーのPIDが格納され、`workers`はこのプールに属するすべてのワーカーの集合です。

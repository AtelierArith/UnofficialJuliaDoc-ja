```
manage(manager::ClusterManager, id::Integer, config::WorkerConfig. op::Symbol)
```

クラスターマネージャーによって実装されます。これは、ワーカーのライフタイム中にマスタープロセスで呼び出され、適切な `op` 値が使用されます：

  * ワーカーがJuliaワーカープールに追加/削除されるときに `:register`/`:deregister` とともに。
  * `interrupt(workers)` が呼び出されたときに `:interrupt` とともに。`ClusterManager` は適切なワーカーに割り込み信号を送信する必要があります。
  * クリーンアップ目的で `:finalize` とともに。

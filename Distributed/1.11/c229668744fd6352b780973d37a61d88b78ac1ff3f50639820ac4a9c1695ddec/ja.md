```julia
manage(manager::ClusterManager, id::Integer, config::WorkerConfig. op::Symbol)
```

クラスタマネージャーによって実装されます。ワーカーの稼働中にマスタープロセス上で呼び出され、状況に応じて次の`op`値が渡されます。

  * Juliaのワーカープールにワーカーが追加／削除されたときは、`:register`／`:deregister`が渡されます。
  * `interrupt(workers)`が呼び出されたときは、`:interrupt`が渡されます。`ClusterManager`は、該当するワーカーに割り込みシグナルを送る必要があります。
  * クリーンアップのために、`:finalize`が渡されます。

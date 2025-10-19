```julia
kill(manager::ClusterManager, pid::Int, config::WorkerConfig)
```

クラスターマネージャによって実装されます。これは、[`rmprocs`](@ref)によってマスタープロセスで呼び出されます。`pid`で指定されたリモートワーカーを終了させるべきです。`kill(manager::ClusterManager.....)`は`pid`でリモートの`exit()`を実行します。

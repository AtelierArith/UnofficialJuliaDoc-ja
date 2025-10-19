```julia
connect(manager::ClusterManager, pid::Int, config::WorkerConfig) -> (instrm::IO, outstrm::IO)
```

クラスターマネージャーによってカスタムトランスポートを使用して実装されます。これは、`config`によって指定された`pid`のワーカーとの論理的な接続を確立し、`IO`オブジェクトのペアを返す必要があります。`pid`から現在のプロセスへのメッセージは`instrm`から読み取られ、`pid`に送信されるメッセージは`outstrm`に書き込まれます。カスタムトランスポートの実装は、メッセージが完全にかつ順序通りに配信され、受信されることを保証しなければなりません。`connect(manager::ClusterManager.....)`は、ワーカー間のTCP/IPソケット接続を設定します。

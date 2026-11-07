```julia
connect(manager::ClusterManager, pid::Int, config::WorkerConfig) -> (instrm::IO, outstrm::IO)
```

カスタムトランスポートを使用するクラスターマネージャーによって実装されます。`config`で指定された、IDが`pid`のワーカーへの論理接続を確立し、`IO`オブジェクトのペアを返します。`pid`から現在のプロセス宛てのメッセージは`instrm`から読み取られ、`pid`宛てに送信するメッセージは`outstrm`に書き込まれます。カスタムトランスポートの実装では、メッセージが完全な形で順序どおりに送受信されるようにする必要があります。`connect(manager::ClusterManager.....)`は、ワーカー間のTCP/IPソケット接続を確立します。

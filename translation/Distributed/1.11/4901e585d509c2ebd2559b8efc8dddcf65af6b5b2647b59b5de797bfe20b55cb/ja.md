```julia
connect(manager::ClusterManager, pid::Int, config::WorkerConfig) -> (instrm::IO, outstrm::IO)
```

カスタムトランスポートを使用するクラスタマネージャーによって実装されます。`config`で指定されたID `pid`のワーカーへの論理接続を確立し、`IO`オブジェクトのペアを返します。`pid`から現在のプロセス宛てのメッセージは`instrm`から読み取られ、`pid`宛てに送信するメッセージは`outstrm`に書き込まれます。カスタムトランスポートの実装では、メッセージが完全な状態で順序どおりに送受信されることを保証する必要があります。`connect(manager::ClusterManager.....)`は、ワーカー間のTCP/IPソケット接続を確立します。

```
Pkg.gc(; collect_delay::Period=Day(7), io::IO=stderr)
```

パッケージとアーティファクトのインストールをガーベジコレクトし、すべての既知の `Manifest.toml` および `Artifacts.toml` ファイルをスイープして、削除されたものを記録し、その後、他のプロジェクトで使用されていないアーティファクトとパッケージを見つけて「孤立」とマークします。このメソッドは、`collect_delay` の期間中に継続的に未使用であった孤立したオブジェクト（パッケージのバージョン、アーティファクト、およびスクラッチスペース）のみを削除します。デフォルトでは、これは7日間です。

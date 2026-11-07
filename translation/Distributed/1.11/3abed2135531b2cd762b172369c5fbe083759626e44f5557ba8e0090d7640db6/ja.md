```julia
worker_id_from_socket(s) -> pid
```

`IO` 接続または `Worker` を受け取り、接続先ワーカーの `pid` を返す低レベル API です。受信側のプロセス ID に応じて書き出すデータを最適化する、型のカスタム [`serialize`](@ref) メソッドを作成する際に役立ちます。

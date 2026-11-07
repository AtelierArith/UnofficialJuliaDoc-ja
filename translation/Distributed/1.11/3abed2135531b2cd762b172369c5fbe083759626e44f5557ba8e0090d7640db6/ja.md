```julia
worker_id_from_socket(s) -> pid
```

`IO` 接続または `Worker` を受け取り、接続先のワーカーの `pid` を返す低レベル API です。型に対するカスタム [`serialize`](@ref) メソッドを作成する際に便利です。受信側プロセスの ID に応じて、書き出すデータを最適化できます。

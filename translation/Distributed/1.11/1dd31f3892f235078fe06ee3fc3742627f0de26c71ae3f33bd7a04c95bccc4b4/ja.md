```
worker_id_from_socket(s) -> pid
```

`IO`接続または`Worker`を与えると、それに接続されているワーカーの`pid`を返す低レベルAPIです。これは、受信プロセスIDに応じて書き出されるデータを最適化するために、型のカスタム[`serialize`](@ref)メソッドを書く際に便利です。

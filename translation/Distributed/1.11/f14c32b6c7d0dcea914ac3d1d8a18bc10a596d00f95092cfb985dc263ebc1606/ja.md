```julia
channel_from_id(id) -> c
```

`remoteref_id`[@ref]によって返された`id`のバックエンド`AbstractChannel`を返す低レベルAPIです。この呼び出しは、バックエンドチャネルが存在するノードでのみ有効です。

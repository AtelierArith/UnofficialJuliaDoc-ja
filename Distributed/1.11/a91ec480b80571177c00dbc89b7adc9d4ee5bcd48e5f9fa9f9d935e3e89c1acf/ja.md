```julia
client_refs
```

特定の`AbstractRemoteRef`（RRIDで識別される）がこのワーカー上に存在するかどうかを追跡します。

`client_refs`ロックは、`.refs`および関連する`clientset`状態へのアクセスを同期するためにも使用されます。

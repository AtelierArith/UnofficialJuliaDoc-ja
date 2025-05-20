```
Base.Pairs(values, keys) <: AbstractDict{eltype(keys), eltype(values)}
```

インデックス可能なコンテナを同じデータの辞書ビューに変換します。基になるデータのキー空間を変更すると、このオブジェクトが無効になる可能性があります。

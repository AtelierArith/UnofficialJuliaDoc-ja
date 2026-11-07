```julia
Base.Pairs(values, keys) <: AbstractDict{eltype(keys), eltype(values)}
```

インデックス可能なコンテナーを、同じデータを参照する辞書ビューに変換します。元データのキー空間を変更すると、このオブジェクトが無効になる場合があります。

```julia
Broadcast.instantiate(bc::Broadcasted)
```

遅延評価される Broadcasted オブジェクト `bc` の軸を構築し、検証します。

カスタム [`BroadcastStyle`](@ref) は、結果の `axes` をオンデマンドで高速かつ容易に計算・検証できる場合、この既定の動作を上書きできます。その場合、`Broadcasted` オブジェクトの `axis` フィールドは空のままにします（[`nothing`](@ref) が設定されます）。

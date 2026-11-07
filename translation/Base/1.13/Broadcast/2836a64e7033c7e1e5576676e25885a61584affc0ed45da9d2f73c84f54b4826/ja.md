```julia
broadcast_preserving_zero_d(f, As...)
```

[`broadcast`](@ref)と同様ですが、結果が0次元の場合は0次元のコンテナを返します。

Broadcastでは、0次元の結果は自動的にアンラップされ、要素そのものになります。しかし、0次元の場合でも常にコンテナを返す必要があることもあります。

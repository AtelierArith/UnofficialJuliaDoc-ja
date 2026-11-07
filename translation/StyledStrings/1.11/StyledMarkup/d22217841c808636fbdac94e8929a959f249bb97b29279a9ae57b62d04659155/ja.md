```julia
addpart!(state::State, stop::Int)
```

`state.point`から`stop`までの範囲を新しいパートとして作成し、保留中のスタイルをすべて適用します。

これにより、`state.point`と  `stop`の間にあるコンテンツがすべて消費され、`state.point`は`stop`の次のインデックスに移動します。

```julia
Profile.add_fake_meta(data; threadid = 1, taskid = 0xf0f0f0f0) -> data_with_meta
```

`Profile.fetch(;include_meta = false)`の逆の操作です。偽のメタデータを追加します。互換性のため、またメタデータ形式の内部仕様への依存を避けたいパッケージ（例：FlameGraphs.jl）で使用できます。

```julia
Profile.add_fake_meta(data; threadid = 1, taskid = 0xf0f0f0f0) -> data_with_meta
```

`Profile.fetch(;include_meta = false)`の逆であり、これは偽のメタデータを追加し、メタデータ形式の内部詳細に依存したくないパッケージ（例：FlameGraphs.jl）や互換性のために使用できます。

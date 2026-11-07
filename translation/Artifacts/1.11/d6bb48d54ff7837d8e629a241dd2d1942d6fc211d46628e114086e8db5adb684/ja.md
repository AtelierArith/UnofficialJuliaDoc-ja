```julia
artifact_paths(hash::SHA1; honor_overrides::Bool=true)
```

`Pkg.depots()` が返す現在のデポ一覧に基づいて、アーティファクトのすべての候補パスを返します。これらのパスは、すべて、いくつか、または一つもディスク上に存在しない場合があります。

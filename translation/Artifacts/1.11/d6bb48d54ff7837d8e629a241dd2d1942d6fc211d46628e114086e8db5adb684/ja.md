```julia
artifact_paths(hash::SHA1; honor_overrides::Bool=true)
```

`Pkg.depots()` が返す現在のデポ一覧に基づいて、アーティファクトのパスをすべて返します。これらのパスは、ディスク上にすべて存在する場合も、一部だけ存在する場合も、まったく存在しない場合もあります。

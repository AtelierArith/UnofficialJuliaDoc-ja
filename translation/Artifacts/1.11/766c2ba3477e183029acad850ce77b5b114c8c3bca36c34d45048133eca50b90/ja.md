```
artifact_paths(hash::SHA1; honor_overrides::Bool=true)
```

現在の `Pkg.depots()` によって返されるデポのリストに基づいて、アーティファクトのすべての可能なパスを返します。これらのパスのすべて、いくつか、またはどれもディスク上に存在しない場合があります。

```julia
range_compressed_versionspec(pool, subset=pool)
```

  * `pool`: 存在するすべてのバージョン（`subset`の上位集合）
  * `subset`: そのうち、仕様に含めるバージョンの部分集合

`subset`のすべてを許可し、それ以外の`pool`を許可しない、最小限の範囲の集合を`VersionSpec`として見つけます。

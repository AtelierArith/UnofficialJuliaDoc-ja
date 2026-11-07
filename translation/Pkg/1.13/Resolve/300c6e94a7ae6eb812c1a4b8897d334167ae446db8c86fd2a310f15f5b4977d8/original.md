```julia
range_compressed_versionspec(pool, subset=pool)
```

  * `pool`: all versions that exist (a superset of `subset`)
  * `subset`: the subset of those versions that we want to include in the spec.

Finds a minimal collection of ranges as a `VersionSpec`, that permits everything in the `subset`, but does not permit anything else from the `pool`.

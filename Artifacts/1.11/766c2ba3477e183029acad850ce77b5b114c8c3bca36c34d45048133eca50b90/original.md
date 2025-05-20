```
artifact_paths(hash::SHA1; honor_overrides::Bool=true)
```

Return all possible paths for an artifact given the current list of depots as returned by `Pkg.depots()`.  All, some or none of these paths may exist on disk.

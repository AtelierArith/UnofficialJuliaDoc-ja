```julia
project_resolve_hash(env::EnvCache, julia_version)
```

The `project_hash` that the Pkg of `julia_version` records in a manifest. A manifest resolved for an older Julia needs that version's hash, or it reports the manifest as out of date with the project. A newer Julia than this one gets this Pkg's hash.

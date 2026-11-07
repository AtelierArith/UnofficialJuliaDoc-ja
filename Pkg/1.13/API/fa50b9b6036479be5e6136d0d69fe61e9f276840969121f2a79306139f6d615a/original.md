```julia
gc(ctx::Context=Context(); verbose=false, force=false, kwargs...)
```

Garbage-collect package and artifact installations by sweeping over all known `Manifest.toml` and `Artifacts.toml` files, noting those that have been deleted, and then finding artifacts and packages that are thereafter not used by any other projects. Unused packages, artifacts, repos, and scratch spaces are immediately deleted.

Garbage collection is only applied to the "user depot", e.g. the first entry in the depot path. If you want to run `gc` on all depots set `force=true` (this might require admin privileges depending on the setup).

Use verbose mode (`verbose=true`) for detailed output.

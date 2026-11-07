```julia
remove_artifact(hash::SHA1; honor_overrides::Bool=false)
```

Removes the given artifact (identified by its SHA1 git tree hash) from disk.  Note that if an artifact is installed in multiple depots, it will be removed from all of them.  If an overridden artifact is requested for removal, it will be silently ignored; this method will never attempt to remove an overridden artifact.

In general, we recommend that you use `Pkg.gc()` to manage artifact installations and do not use `remove_artifact()` directly, as it can be difficult to know if an artifact is being used by another package.

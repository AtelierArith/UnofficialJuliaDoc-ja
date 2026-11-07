```julia
verify_artifact(hash::SHA1; honor_overrides::Bool=false)
```

Verifies that the given artifact (identified by its SHA1 git tree hash) is installed on- disk, and retains its integrity.  If the given artifact is overridden, skips the verification unless `honor_overrides` is set to `true`.

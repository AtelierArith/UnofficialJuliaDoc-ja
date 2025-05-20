```
artifact_exists(hash::SHA1; honor_overrides::Bool=true)
```

Return whether or not the given artifact (identified by its sha1 git tree hash) exists on-disk.  Note that it is possible that the given artifact exists in multiple locations (e.g. within multiple depots).

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.


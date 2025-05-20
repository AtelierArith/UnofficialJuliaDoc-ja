```
artifact_path(hash::SHA1; honor_overrides::Bool=true)
```

Given an artifact (identified by SHA1 git tree hash), return its installation path.  If the artifact does not exist, returns the location it would be installed to.

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.


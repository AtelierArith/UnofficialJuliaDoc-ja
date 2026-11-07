```julia
artifact_hash(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform())
```

Thin wrapper around `artifact_meta()` to return the hash of the specified, platform- collapsed artifact.  Returns `nothing` if no mapping can be found.

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.


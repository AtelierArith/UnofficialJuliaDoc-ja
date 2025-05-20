```
artifact_meta(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform(),
              pkg_uuid::Union{Base.UUID,Nothing}=nothing)
```

Get metadata about a given artifact (identified by name) stored within the given `(Julia)Artifacts.toml` file.  If the artifact is platform-specific, use `platform` to choose the most appropriate mapping.  If none is found, return `nothing`.

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.


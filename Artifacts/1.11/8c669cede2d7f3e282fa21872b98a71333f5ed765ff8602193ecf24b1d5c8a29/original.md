```
load_artifacts_toml(artifacts_toml::String;
                    pkg_uuid::Union{UUID,Nothing}=nothing)
```

Loads an `(Julia)Artifacts.toml` file from disk.  If `pkg_uuid` is set to the `UUID` of the owning package, UUID/name overrides stored in a depot `Overrides.toml` will be resolved.

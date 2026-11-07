```julia
extract_all_hashes(artifacts_toml::String;
                    platform = HostPlatform(),
                    pkg_uuid = nothing,
                    include_lazy = false)
```

Extract all hashes from a given `(Julia)Artifacts.toml` file. `package_uuid` must be provided to properly support overrides from `Overrides.toml` entries in depots.

If `include_lazy` is set to `true`, then lazy packages will be installed as well.

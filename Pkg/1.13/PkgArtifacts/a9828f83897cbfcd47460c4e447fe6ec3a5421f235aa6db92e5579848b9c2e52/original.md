```julia
ensure_all_artifacts_installed(artifacts_toml::String;
                                platform = HostPlatform(),
                                pkg_uuid = nothing,
                                include_lazy = false,
                                verbose = false,
                                quiet_download = false,
                                io::IO=stderr)
```

Installs all non-lazy artifacts from a given `(Julia)Artifacts.toml` file. `package_uuid` must be provided to properly support overrides from `Overrides.toml` entries in depots.

If `include_lazy` is set to `true`, then lazy packages will be installed as well.

This function is deprecated and should be replaced with the following snippet:

```julia
artifacts = select_downloadable_artifacts(artifacts_toml; platform, include_lazy)
for name in keys(artifacts)
    ensure_artifact_installed(name, artifacts[name], artifacts_toml; platform=platform)
end
```

!!! warning
    This function is deprecated in Julia 1.6 and will be removed in a future version. Use `select_downloadable_artifacts()` and `ensure_artifact_installed()` instead.


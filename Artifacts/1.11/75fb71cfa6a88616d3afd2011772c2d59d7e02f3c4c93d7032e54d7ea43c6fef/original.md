```
select_downloadable_artifacts(artifacts_toml::String;
                              platform = HostPlatform,
                              include_lazy = false,
                              pkg_uuid = nothing)
```

Return a dictionary where every entry is an artifact from the given `Artifacts.toml` that should be downloaded for the requested platform.  Lazy artifacts are included if `include_lazy` is set.

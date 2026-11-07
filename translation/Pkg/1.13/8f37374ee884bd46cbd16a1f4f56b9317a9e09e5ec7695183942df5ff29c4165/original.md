```julia
normalize_path_for_toml(path::String)
```

Normalize a path for writing to TOML files (Project.toml/Manifest.toml). On Windows, converts relative paths to use forward slashes for cross-platform compatibility. Absolute paths are left unchanged as they are platform-specific by nature.

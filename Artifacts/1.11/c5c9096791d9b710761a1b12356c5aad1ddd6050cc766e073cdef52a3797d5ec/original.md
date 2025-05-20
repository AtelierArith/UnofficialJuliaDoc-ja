```
process_overrides(artifact_dict::Dict, pkg_uuid::Base.UUID)
```

When loading an `Artifacts.toml` file, we must check `Overrides.toml` files to see if any of the artifacts within it have been overridden by UUID.  If they have, we honor the overrides by inspecting the hashes of the targeted artifacts, then overriding them to point to the given override, punting the actual redirection off to the hash-based override system.  This does not modify the `artifact_dict` object, it merely dynamically adds more hash-based overrides as `Artifacts.toml` files that are overridden are loaded.

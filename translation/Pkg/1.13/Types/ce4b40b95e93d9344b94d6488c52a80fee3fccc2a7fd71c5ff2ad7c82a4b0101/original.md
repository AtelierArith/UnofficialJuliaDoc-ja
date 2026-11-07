```julia
ManifestRegistryEntry
```

Metadata about a registry referenced from a manifest. `id` is the stable key written to the manifest (typically the registry name, falling back to UUID on collision). Only `uuid` and `url` are written to the manifest file.

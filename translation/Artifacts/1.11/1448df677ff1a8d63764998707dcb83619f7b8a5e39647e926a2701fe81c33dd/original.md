```
query_override(hash::SHA1; overrides::Dict = load_overrides())
```

Query the loaded `<DEPOT>/artifacts/Overrides.toml` settings for artifacts that should be redirected to a particular path or another content-hash.

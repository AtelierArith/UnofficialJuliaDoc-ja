```
unpack_platform(entry::Dict, name::String, artifacts_toml::String)
```

Given an `entry` for the artifact named `name`, located within the file `artifacts_toml`, returns the `Platform` object that this entry specifies.  Returns `nothing` on error.

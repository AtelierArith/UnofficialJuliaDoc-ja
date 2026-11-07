```julia
unbind_artifact!(artifacts_toml::String, name::String; platform = nothing)
```

Unbind the given `name` from an `(Julia)Artifacts.toml` file. Silently fails if no such binding exists within the file.

```julia
bind_artifact!(artifacts_toml::String, name::String, hash::SHA1;
                platform::Union{AbstractPlatform,Nothing} = nothing,
                download_info::Union{Vector{Tuple},Nothing} = nothing,
                lazy::Bool = false,
                force::Bool = false)
```

Writes a mapping of `name` -> `hash` within the given `(Julia)Artifacts.toml` file. If `platform` is not `nothing`, this artifact is marked as platform-specific, and will be a multi-mapping.  It is valid to bind multiple artifacts with the same name, but different `platform`s and `hash`'es within the same `artifacts_toml`.  If `force` is set to `true`, this will overwrite a pre-existant mapping, otherwise an error is raised.

`download_info` is an optional vector that contains tuples of URLs and a hash.  These URLs will be listed as possible locations where this artifact can be obtained.  If `lazy` is set to `true`, even if download information is available, this artifact will not be downloaded until it is accessed via the `artifact"name"` syntax, or `ensure_artifact_installed()` is called upon it.

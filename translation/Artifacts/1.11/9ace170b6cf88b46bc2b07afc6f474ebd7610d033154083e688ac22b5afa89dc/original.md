```
artifact_slash_lookup(name::String, atifact_dict::Dict,
                      artifacts_toml::String, platform::Platform)
```

Return `artifact_name`, `artifact_path_tail`, and `hash` by looking the results up in the given `artifacts_toml`, first extracting the name and path tail from the given `name` to support slash-indexing within the given artifact.

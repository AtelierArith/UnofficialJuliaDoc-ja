```julia
artifact_slash_lookup(name::String, atifact_dict::Dict,
                      artifacts_toml::String, platform::Platform)
```

指定された `name` から名前とパスの末尾を抽出し、指定された成果物内でスラッシュインデックスを使えるようにしたうえで、指定された `artifacts_toml` を参照して `artifact_name`、`artifact_path_tail`、`hash` を返してください。

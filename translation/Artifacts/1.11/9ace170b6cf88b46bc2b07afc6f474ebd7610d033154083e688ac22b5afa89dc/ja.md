```
artifact_slash_lookup(name::String, atifact_dict::Dict,
                      artifacts_toml::String, platform::Platform)
```

`artifact_name`、`artifact_path_tail`、および `hash` を返します。これは、与えられた `artifacts_toml` で結果を検索し、与えられた `name` から名前とパスの尾を最初に抽出して、与えられたアーティファクト内でスラッシュインデックスをサポートします。

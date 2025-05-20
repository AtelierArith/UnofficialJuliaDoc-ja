```
unpack_platform(entry::Dict, name::String, artifacts_toml::String)
```

指定された `artifacts_toml` ファイル内の `name` という名前のアーティファクトに対する `entry` が与えられた場合、このエントリが指定する `Platform` オブジェクトを返します。 エラーが発生した場合は `nothing` を返します。

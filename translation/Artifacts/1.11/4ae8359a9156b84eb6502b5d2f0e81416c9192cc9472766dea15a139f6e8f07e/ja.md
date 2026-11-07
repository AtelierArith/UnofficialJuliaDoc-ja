```julia
unpack_platform(entry::Dict, name::String, artifacts_toml::String)
```

ファイル `artifacts_toml` 内にある、アーティファクト `name` を指定する `entry` が与えられると、このエントリが指定する `Platform` オブジェクトを返します。エラーが発生した場合は `nothing` を返します。

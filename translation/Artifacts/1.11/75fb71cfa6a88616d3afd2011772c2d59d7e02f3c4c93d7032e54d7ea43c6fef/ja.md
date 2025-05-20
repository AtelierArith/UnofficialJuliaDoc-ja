```
select_downloadable_artifacts(artifacts_toml::String;
                              platform = HostPlatform,
                              include_lazy = false,
                              pkg_uuid = nothing)
```

指定されたプラットフォームのためにダウンロードすべき `Artifacts.toml` からのすべてのエントリを含む辞書を返します。 `include_lazy` が設定されている場合は、遅延アーティファクトも含まれます。

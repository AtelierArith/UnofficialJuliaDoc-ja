```julia
select_downloadable_artifacts(artifacts_toml::String;
                              platform = HostPlatform,
                              include_lazy = false,
                              pkg_uuid = nothing)
```

指定されたプラットフォーム向けにダウンロードすべきアーティファクトをすべて含む辞書を返します。各エントリは、指定された`Artifacts.toml`のアーティファクトです。`include_lazy`が設定されている場合は、遅延アーティファクトも含まれます。
